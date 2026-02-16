package hollybike.api.utils

import kotlin.math.*

data class PositionSample(
	val timeMillis: Long,
	val lat: Double,
	val lon: Double,
	val alt: Double,
	val accuracyM: Double,
	val speedMps: Double?,
	val ax: Double?,          // m/s^2
	val ay: Double?,          // m/s^2
	val az: Double?           // m/s^2
)

data class EkfState(
	val x: Double,  // meters (local)
	val y: Double,  // meters (local)
	val vx: Double, // m/s
	val vy: Double  // m/s
)

data class FilterStep(
	val tMillis: Long,
	val xPred: EkfState,
	val PPred: DoubleArray,     // 4x4 row-major
	val xFilt: EkfState,
	val PFilt: DoubleArray,     // 4x4 row-major
	val F: DoubleArray          // 4x4 row-major (linearized)
) {
	override fun equals(other: Any?): Boolean {
		if (this === other) return true
		if (javaClass != other?.javaClass) return false

		other as FilterStep

		if (tMillis != other.tMillis) return false
		if (xPred != other.xPred) return false
		if (!PPred.contentEquals(other.PPred)) return false
		if (xFilt != other.xFilt) return false
		if (!PFilt.contentEquals(other.PFilt)) return false
		if (!F.contentEquals(other.F)) return false

		return true
	}

	override fun hashCode(): Int {
		var result = tMillis.hashCode()
		result = 31 * result + xPred.hashCode()
		result = 31 * result + PPred.contentHashCode()
		result = 31 * result + xFilt.hashCode()
		result = 31 * result + PFilt.contentHashCode()
		result = 31 * result + F.contentHashCode()
		return result
	}
}

object EkfJourney {

	// --- Local tangent plane projection (equirectangular) ---
	data class Origin(val lat0Rad: Double, val lon0Rad: Double, val cosLat0: Double)

	fun originFrom(lat: Double, lon: Double): Origin {
		val lat0Rad = Math.toRadians(lat)
		val lon0Rad = Math.toRadians(lon)
		return Origin(lat0Rad, lon0Rad, cos(lat0Rad))
	}

	// WGS84 mean Earth radius for local approximation
	private const val R_EARTH = 6371000.0

	fun latLonToXY(origin: Origin, lat: Double, lon: Double): Pair<Double, Double> {
		val latRad = Math.toRadians(lat)
		val lonRad = Math.toRadians(lon)
		val x = (lonRad - origin.lon0Rad) * origin.cosLat0 * R_EARTH
		val y = (latRad - origin.lat0Rad) * R_EARTH
		return x to y
	}

	fun xyToLatLon(origin: Origin, x: Double, y: Double): Pair<Double, Double> {
		val latRad = y / R_EARTH + origin.lat0Rad
		val lonRad = x / (R_EARTH * origin.cosLat0) + origin.lon0Rad
		return Math.toDegrees(latRad) to Math.toDegrees(lonRad)
	}

	// --- Matrix helpers (4x4 only, row-major) ---
	private fun eye4(): DoubleArray = doubleArrayOf(
		1.0,0.0,0.0,0.0,
		0.0,1.0,0.0,0.0,
		0.0,0.0,1.0,0.0,
		0.0,0.0,0.0,1.0
	)

	private fun mat4Mul(A: DoubleArray, B: DoubleArray): DoubleArray {
		val C = DoubleArray(16)
		for (r in 0..3) for (c in 0..3) {
			var s = 0.0
			for (k in 0..3) s += A[r*4+k] * B[k*4+c]
			C[r*4+c] = s
		}
		return C
	}

	private fun mat4Add(A: DoubleArray, B: DoubleArray): DoubleArray =
		DoubleArray(16) { i -> A[i] + B[i] }

	private fun mat4Sub(A: DoubleArray, B: DoubleArray): DoubleArray =
		DoubleArray(16) { i -> A[i] - B[i] }

	private fun mat4Transpose(A: DoubleArray): DoubleArray {
		val T = DoubleArray(16)
		for (r in 0..3) for (c in 0..3) T[c*4+r] = A[r*4+c]
		return T
	}

	private fun mat4Vec(A: DoubleArray, v: DoubleArray): DoubleArray {
		val out = DoubleArray(4)
		for (r in 0..3) {
			out[r] = A[r*4+0]*v[0] + A[r*4+1]*v[1] + A[r*4+2]*v[2] + A[r*4+3]*v[3]
		}
		return out
	}

	private fun vecSub(a: DoubleArray, b: DoubleArray): DoubleArray = DoubleArray(a.size) { i -> a[i] - b[i] }

	// --- Small matrix ops for EKF measurement update ---
	// Measurement is z = [x_gps, y_gps, speed]  (speed optional)
	// H is 3x4 (or 2x4 if no speed)
	private fun matMul(A: Array<DoubleArray>, B: DoubleArray, rows: Int, cols: Int): Array<DoubleArray> {
		// A: rows x 4, B: 4x4 -> result rows x 4
		val out = Array(rows) { DoubleArray(4) }
		for (r in 0 until rows) for (c in 0..3) {
			var s = 0.0
			for (k in 0..3) s += A[r][k] * B[k*4+c]
			out[r][c] = s
		}
		return out
	}

	private fun matMul2(A: Array<DoubleArray>, B: Array<DoubleArray>, rowsA: Int, colsB: Int, inner: Int): Array<DoubleArray> {
		val out = Array(rowsA) { DoubleArray(colsB) }
		for (r in 0 until rowsA) for (c in 0 until colsB) {
			var s = 0.0
			for (k in 0 until inner) s += A[r][k] * B[k][c]
			out[r][c] = s
		}
		return out
	}

	private fun matTrans(A: Array<DoubleArray>): Array<DoubleArray> {
		val out = Array(A[0].size) { DoubleArray(A.size) }
		for (r in A.indices) for (c in A[0].indices) out[c][r] = A[r][c]
		return out
	}

	// Invert 2x2 / 3x3 (only what we need)
	private fun inv2(S: Array<DoubleArray>): Array<DoubleArray> {
		val a = S[0][0]; val b = S[0][1]
		val c = S[1][0]; val d = S[1][1]
		val det = a*d - b*c
		require(abs(det) > 1e-12) { "Singular 2x2" }
		val invDet = 1.0 / det
		return arrayOf(
			doubleArrayOf( d*invDet, -b*invDet),
			doubleArrayOf(-c*invDet,  a*invDet)
		)
	}

	private fun inv3(S: Array<DoubleArray>): Array<DoubleArray> {
		val a = S[0][0]; val b = S[0][1]; val c = S[0][2]
		val d = S[1][0]; val e = S[1][1]; val f = S[1][2]
		val g = S[2][0]; val h = S[2][1]; val i = S[2][2]
		val A =  (e*i - f*h)
		val B = -(d*i - f*g)
		val C =  (d*h - e*g)
		val D = -(b*i - c*h)
		val E =  (a*i - c*g)
		val F = -(a*h - b*g)
		val G =  (b*f - c*e)
		val H = -(a*f - c*d)
		val I =  (a*e - b*d)
		val det = a*A + b*B + c*C
		require(abs(det) > 1e-12) { "Singular 3x3" }
		val invDet = 1.0 / det
		return arrayOf(
			doubleArrayOf(A*invDet, D*invDet, G*invDet),
			doubleArrayOf(B*invDet, E*invDet, H*invDet),
			doubleArrayOf(C*invDet, F*invDet, I*invDet)
		)
	}

	private fun mahaSquared(r: DoubleArray, SInv: Array<DoubleArray>): Double {
		// r^T SInv r
		val tmp = DoubleArray(r.size)
		for (row in r.indices) {
			var s = 0.0
			for (col in r.indices) s += SInv[row][col] * r[col]
			tmp[row] = s
		}
		var out = 0.0
		for (k in r.indices) out += r[k] * tmp[k]
		return out
	}

	// --- EKF forward + RTS smoother ---
	fun smoothTrajectory(samples: List<PositionSample>): Pair<List<EkfState>, Origin> {
		require(samples.size >= 2)
		val s0 = samples.first()
		val origin = originFrom(s0.lat, s0.lon)

		// Initial state from first sample; velocity unknown -> 0 (large covariance)
		val (x0, y0) = latLonToXY(origin, s0.lat, s0.lon)
		var x = EkfState(x0, y0, 0.0, 0.0)

		// Initial covariance (tune)
		var P = doubleArrayOf(
			25.0,0.0,0.0,0.0,
			0.0,25.0,0.0,0.0,
			0.0,0.0,100.0,0.0,
			0.0,0.0,0.0,100.0
		)

		// Process noise base (tune)
		val sigmaAccel = 2.0     // m/s^2 (how “wiggly” motion is)
		val steps = ArrayList<FilterStep>(samples.size)

		for (idx in samples.indices) {
			val s = samples[idx]
			val t = s.timeMillis
			val (zx, zy) = latLonToXY(origin, s.lat, s.lon)

			// Predict
			val dt = if (idx == 0) 0.0 else (t - samples[idx - 1].timeMillis).coerceAtLeast(1L) / 1000.0

			val F = eye4().apply {
				this[0*4+2] = dt
				this[1*4+3] = dt
			}

			// Discrete white-noise acceleration model (CV with accel noise)
			// Q = sigma_a^2 * [[dt^4/4,0,dt^3/2,0], [0,dt^4/4,0,dt^3/2], [dt^3/2,0,dt^2,0], [0,dt^3/2,0,dt^2]]
			val dt2 = dt*dt
			val dt3 = dt2*dt
			val dt4 = dt2*dt2
			val sa2 = sigmaAccel * sigmaAccel

			val Q = doubleArrayOf(
				sa2*dt4/4, 0.0,         sa2*dt3/2, 0.0,
				0.0,        sa2*dt4/4,   0.0,        sa2*dt3/2,
				sa2*dt3/2,  0.0,         sa2*dt2,    0.0,
				0.0,        sa2*dt3/2,   0.0,        sa2*dt2
			)

			val xPred = EkfState(
				x = x.x + x.vx * dt,
				y = x.y + x.vy * dt,
				vx = x.vx,
				vy = x.vy
			)

			val PPred = mat4Add(mat4Mul(mat4Mul(F, P), mat4Transpose(F)), Q)

			// Update (EKF): z = [x_gps, y_gps, speed]
			// Measurement noise from accuracy
			val sigmaPos = max(1.0, s.accuracyM) // clamp
			val rPos2 = sigmaPos * sigmaPos

			val useSpeed = (s.speedMps != null && s.speedMps.isFinite())
			val m = if (useSpeed) 3 else 2

			// h(x)
			val v = hypot(xPred.vx, xPred.vy)
			val h = if (useSpeed) doubleArrayOf(xPred.x, xPred.y, v) else doubleArrayOf(xPred.x, xPred.y)

			val z = if (useSpeed) doubleArrayOf(zx, zy, s.speedMps!!) else doubleArrayOf(zx, zy)
			val r = vecSub(z, h)

			// H = dh/dx
			val H = Array(m) { DoubleArray(4) }
			// position rows
			H[0][0] = 1.0; H[0][1] = 0.0; H[0][2] = 0.0; H[0][3] = 0.0
			H[1][0] = 0.0; H[1][1] = 1.0; H[1][2] = 0.0; H[1][3] = 0.0

			if (useSpeed) {
				// speed = sqrt(vx^2 + vy^2)
				val eps = 1e-6
				val denom = max(eps, v)
				H[2][2] = xPred.vx / denom
				H[2][3] = xPred.vy / denom
			}

			// R
			val R = Array(m) { DoubleArray(m) }
			R[0][0] = rPos2
			R[1][1] = rPos2
			if (useSpeed) {
				// speed noise (tune). If you trust GPS speed a lot, lower this.
				val sigmaSpeed = 1.5 // m/s
				R[2][2] = sigmaSpeed * sigmaSpeed
			}

			// S = H P H^T + R
			val HP = matMul(H, PPred, m, 4)
			val S = matMul2(HP, matTrans(H), m, m, 4)
			for (i in 0 until m) for (j in 0 until m) S[i][j] += R[i][j]

			val SInv = when (m) {
				2 -> inv2(S)
				3 -> inv3(S)
				else -> error("Unsupported m=$m")
			}

			// Robust gating (Chi-square)
			// df=2: 95% ~ 5.99, 99% ~ 9.21
			// df=3: 95% ~ 7.81, 99% ~ 11.34
			val gate = if (m == 2) 9.21 else 11.34 // ~99% gate
			val d2 = mahaSquared(r, SInv)

			val xFilt: EkfState
			val PFilt: DoubleArray

			if (d2 > gate) {
				// Reject this measurement as outlier -> keep prediction
				xFilt = xPred
				PFilt = PPred
			} else {
				// K = P H^T S^-1   (4xm)
				val Ht = matTrans(H) // 4xm
				// Compute PHt (4xm)
				val PHt = Array(4) { DoubleArray(m) }
				for (row in 0..3) for (col in 0 until m) {
					var ssum = 0.0
					for (k in 0..3) ssum += PPred[row*4+k] * Ht[k][col]
					PHt[row][col] = ssum
				}
				// K = PHt * SInv (4xm)
				val K = Array(4) { DoubleArray(m) }
				for (row in 0..3) for (col in 0 until m) {
					var ssum = 0.0
					for (k in 0 until m) ssum += PHt[row][k] * SInv[k][col]
					K[row][col] = ssum
				}

				// x = xPred + K r
				val dx = DoubleArray(4)
				for (row in 0..3) {
					var ssum = 0.0
					for (k in 0 until m) ssum += K[row][k] * r[k]
					dx[row] = ssum
				}
				xFilt = EkfState(
					x = xPred.x + dx[0],
					y = xPred.y + dx[1],
					vx = xPred.vx + dx[2],
					vy = xPred.vy + dx[3]
				)

				// P = (I - K H) PPred
				val KH = Array(4) { DoubleArray(4) }
				for (r0 in 0..3) for (c0 in 0..3) {
					var ssum = 0.0
					for (k in 0 until m) ssum += K[r0][k] * H[k][c0]
					KH[r0][c0] = ssum
				}
				val IminusKH = Array(4) { r0 -> DoubleArray(4) { c0 -> (if (r0 == c0) 1.0 else 0.0) - KH[r0][c0] } }
				// PFilt = (I-KH) PPred
				val outP = DoubleArray(16)
				for (r0 in 0..3) for (c0 in 0..3) {
					var ssum = 0.0
					for (k in 0..3) ssum += IminusKH[r0][k] * PPred[k*4+c0]
					outP[r0*4+c0] = ssum
				}
				PFilt = outP
			}

			steps += FilterStep(
				tMillis = t,
				xPred = xPred,
				PPred = PPred,
				xFilt = xFilt,
				PFilt = PFilt,
				F = F
			)

			x = xFilt
			P = PFilt
		}

		// RTS smoother (uses stored F, PPred, PFilt)
		val smoothed = MutableList(steps.size) { steps[it].xFilt }
		var Ps = steps.last().PFilt

		for (k in steps.size - 2 downTo 0) {
			val stepK = steps[k]
			val stepK1 = steps[k + 1]

			val Pk = stepK.PFilt
			val Pk1Pred = stepK1.PPred
			val Fk1 = stepK1.F

			// Compute smoother gain: Ck = Pk F^T (Pk+1_pred)^-1
			// We’ll invert 4x4 with a simple Gauss-Jordan (since it’s only 4x4)
			val PkF_T = mat4Mul(Pk, mat4Transpose(Fk1))
			val invPk1Pred = inv4GaussJordan(Pk1Pred)

			val Ck = mat4Mul(PkF_T, invPk1Pred)

			// xs = xf + Ck (x_{k+1}^s - x_{k+1}^pred)
			val xk = stepK.xFilt
			val xk1s = smoothed[k + 1]
			val xk1pred = stepK1.xPred
			val diff = doubleArrayOf(
				xk1s.x - xk1pred.x,
				xk1s.y - xk1pred.y,
				xk1s.vx - xk1pred.vx,
				xk1s.vy - xk1pred.vy
			)
			val corr = mat4Vec(Ck, diff)
			val xks = EkfState(
				x = xk.x + corr[0],
				y = xk.y + corr[1],
				vx = xk.vx + corr[2],
				vy = xk.vy + corr[3]
			)
			smoothed[k] = xks

			// Ps = Pk + Ck (Ps_{k+1} - Pk+1_pred) Ck^T
			val PsNext = Ps
			val middle = mat4Sub(PsNext, Pk1Pred)
			val PsNew = mat4Add(Pk, mat4Mul(mat4Mul(Ck, middle), mat4Transpose(Ck)))
			Ps = PsNew
		}

		return smoothed to origin
	}

	private fun inv4GaussJordan(A: DoubleArray): DoubleArray {
		// 4x4 inversion via Gauss-Jordan; A row-major
		val M = Array(4) { r -> DoubleArray(8) }
		for (r in 0..3) {
			for (c in 0..3) M[r][c] = A[r*4+c]
			for (c in 0..3) M[r][4+c] = if (r == c) 1.0 else 0.0
		}
		for (col in 0..3) {
			// pivot
			var pivotRow = col
			var maxAbs = abs(M[col][col])
			for (r in col+1..3) {
				val v = abs(M[r][col])
				if (v > maxAbs) { maxAbs = v; pivotRow = r }
			}
			require(maxAbs > 1e-12) { "Singular 4x4" }
			if (pivotRow != col) {
				val tmp = M[col]; M[col] = M[pivotRow]; M[pivotRow] = tmp
			}
			val piv = M[col][col]
			for (c in col until 8) M[col][c] /= piv
			for (r in 0..3) {
				if (r == col) continue
				val f = M[r][col]
				for (c in col until 8) M[r][c] -= f * M[col][c]
			}
		}
		val inv = DoubleArray(16)
		for (r in 0..3) for (c in 0..3) inv[r*4+c] = M[r][4+c]
		return inv
	}
}
