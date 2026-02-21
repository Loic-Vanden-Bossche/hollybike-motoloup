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
	val pPred: DoubleArray,     // 4x4 row-major
	val xFilt: EkfState,
	val pFilt: DoubleArray,     // 4x4 row-major
	val f: DoubleArray          // 4x4 row-major (linearized)
) {
	override fun equals(other: Any?): Boolean {
		if (this === other) return true
		if (javaClass != other?.javaClass) return false

		other as FilterStep

		if (tMillis != other.tMillis) return false
		if (xPred != other.xPred) return false
		if (!pPred.contentEquals(other.pPred)) return false
		if (xFilt != other.xFilt) return false
		if (!pFilt.contentEquals(other.pFilt)) return false
		if (!f.contentEquals(other.f)) return false

		return true
	}

	override fun hashCode(): Int {
		var result = tMillis.hashCode()
		result = 31 * result + xPred.hashCode()
		result = 31 * result + pPred.contentHashCode()
		result = 31 * result + xFilt.hashCode()
		result = 31 * result + pFilt.contentHashCode()
		result = 31 * result + f.contentHashCode()
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

	private fun mat4Mul(a: DoubleArray, b: DoubleArray): DoubleArray {
		val out = DoubleArray(16)
		for (r in 0..3) for (c in 0..3) {
			var s = 0.0
			for (k in 0..3) s += a[r*4+k] * b[k*4+c]
			out[r*4+c] = s
		}
		return out
	}

	private fun mat4Add(a: DoubleArray, b: DoubleArray): DoubleArray =
		DoubleArray(16) { i -> a[i] + b[i] }

	private fun mat4Sub(a: DoubleArray, b: DoubleArray): DoubleArray =
		DoubleArray(16) { i -> a[i] - b[i] }

	private fun mat4Transpose(a: DoubleArray): DoubleArray {
		val t = DoubleArray(16)
		for (r in 0..3) for (c in 0..3) t[c*4+r] = a[r*4+c]
		return t
	}

	private fun mat4Vec(a: DoubleArray, v: DoubleArray): DoubleArray {
		val out = DoubleArray(4)
		for (r in 0..3) {
			out[r] = a[r*4+0]*v[0] + a[r*4+1]*v[1] + a[r*4+2]*v[2] + a[r*4+3]*v[3]
		}
		return out
	}

	private fun vecSub(a: DoubleArray, b: DoubleArray): DoubleArray = DoubleArray(a.size) { i -> a[i] - b[i] }

	// --- Small matrix ops for EKF measurement update ---
	// Measurement is z = [x_gps, y_gps, speed]  (speed optional)
	// H is 3x4 (or 2x4 if no speed)
	private fun matMul(a: Array<DoubleArray>, b: DoubleArray, rows: Int): Array<DoubleArray> {
		// A: rows x 4, B: 4x4 -> result rows x 4
		val out = Array(rows) { DoubleArray(4) }
		for (r in 0 until rows) for (c in 0..3) {
			var s = 0.0
			for (k in 0..3) s += a[r][k] * b[k*4+c]
			out[r][c] = s
		}
		return out
	}

	private fun matMul2(a: Array<DoubleArray>, b: Array<DoubleArray>, rowsA: Int, colsB: Int): Array<DoubleArray> {
		val inner = b.size
		val out = Array(rowsA) { DoubleArray(colsB) }
		for (r in 0 until rowsA) for (c in 0 until colsB) {
			var s = 0.0
			for (k in 0 until inner) s += a[r][k] * b[k][c]
			out[r][c] = s
		}
		return out
	}

	private fun matTrans(a: Array<DoubleArray>): Array<DoubleArray> {
		val out = Array(a[0].size) { DoubleArray(a.size) }
		for (r in a.indices) for (c in a[0].indices) out[c][r] = a[r][c]
		return out
	}

	// Invert 2x2 / 3x3 (only what we need)
	private fun inv2(s: Array<DoubleArray>): Array<DoubleArray> {
		val a = s[0][0]; val b = s[0][1]
		val c = s[1][0]; val d = s[1][1]
		val det = a*d - b*c
		require(abs(det) > 1e-12) { "Singular 2x2" }
		val invDet = 1.0 / det
		return arrayOf(
			doubleArrayOf( d*invDet, -b*invDet),
			doubleArrayOf(-c*invDet,  a*invDet)
		)
	}

	private fun inv3(s: Array<DoubleArray>): Array<DoubleArray> {
		val a = s[0][0]; val b = s[0][1]; val c = s[0][2]
		val d = s[1][0]; val e = s[1][1]; val f = s[1][2]
		val g = s[2][0]; val h = s[2][1]; val i = s[2][2]

		val cofactors = arrayOf(
			doubleArrayOf(e * i - f * h, -(d * i - f * g), d * h - e * g),
			doubleArrayOf(-(b * i - c * h), a * i - c * g, -(a * h - b * g)),
			doubleArrayOf(b * f - c * e, -(a * f - c * d), a * e - b * d)
		)
		val det = a * cofactors[0][0] + b * cofactors[0][1] + c * cofactors[0][2]
		require(abs(det) > 1e-12) { "Singular 3x3" }
		val invDet = 1.0 / det
		return Array(3) { row -> DoubleArray(3) { col -> cofactors[row][col] * invDet } }
	}

	private fun mahaSquared(r: DoubleArray, sInv: Array<DoubleArray>): Double {
		// r^T SInv r
		val tmp = DoubleArray(r.size)
		for (row in r.indices) {
			var s = 0.0
			for (col in r.indices) s += sInv[row][col] * r[col]
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
		var p = doubleArrayOf(
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

			val f = eye4().apply {
				this[0*4+2] = dt
				this[1*4+3] = dt
			}

			// Discrete white-noise acceleration model (CV with accel noise)
			// Q = sigma_a^2 * [[dt^4/4,0,dt^3/2,0], [0,dt^4/4,0,dt^3/2], [dt^3/2,0,dt^2,0], [0,dt^3/2,0,dt^2]]
			val dt2 = dt*dt
			val dt3 = dt2*dt
			val dt4 = dt2*dt2
			val sa2 = sigmaAccel * sigmaAccel

			val q = doubleArrayOf(
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

			val pPred = mat4Add(mat4Mul(mat4Mul(f, p), mat4Transpose(f)), q)

			// Update (EKF): z = [x_gps, y_gps, speed]
			// Measurement noise from accuracy
			val sigmaPos = max(1.0, s.accuracyM) // clamp
			val rPos2 = sigmaPos * sigmaPos

			val useSpeed = (s.speedMps != null && s.speedMps.isFinite())
			val m = if (useSpeed) 3 else 2

			// h(x)
			val v = hypot(xPred.vx, xPred.vy)
			val h = if (useSpeed) doubleArrayOf(xPred.x, xPred.y, v) else doubleArrayOf(xPred.x, xPred.y)

			val z = if (useSpeed) doubleArrayOf(zx, zy, s.speedMps) else doubleArrayOf(zx, zy)
			val r = vecSub(z, h)

			// H = dh/dx
			val hJacobian = Array(m) { DoubleArray(4) }
			// position rows
			hJacobian[0][0] = 1.0; hJacobian[0][1] = 0.0; hJacobian[0][2] = 0.0; hJacobian[0][3] = 0.0
			hJacobian[1][0] = 0.0; hJacobian[1][1] = 1.0; hJacobian[1][2] = 0.0; hJacobian[1][3] = 0.0

			if (useSpeed) {
				// speed = sqrt(vx^2 + vy^2)
				val eps = 1e-6
				val denom = max(eps, v)
				hJacobian[2][2] = xPred.vx / denom
				hJacobian[2][3] = xPred.vy / denom
			}

			// R
			val rCov = Array(m) { DoubleArray(m) }
			rCov[0][0] = rPos2
			rCov[1][1] = rPos2
			if (useSpeed) {
				// speed noise (tune). If you trust GPS speed a lot, lower this.
				val sigmaSpeed = 1.5 // m/s
				rCov[2][2] = sigmaSpeed * sigmaSpeed
			}

			// S = H P H^T + R
			val hp = matMul(hJacobian, pPred, m)
			val sCov = matMul2(hp, matTrans(hJacobian), m, m)
			for (i in 0 until m) for (j in 0 until m) sCov[i][j] += rCov[i][j]

			val sInv = when (m) {
				2 -> inv2(sCov)
				3 -> inv3(sCov)
				else -> error("Unsupported m=$m")
			}

			// Robust gating (Chi-square)
			// df=2: 95% ~ 5.99, 99% ~ 9.21
			// df=3: 95% ~ 7.81, 99% ~ 11.34
			val gate = if (m == 2) 9.21 else 11.34 // ~99% gate
			val d2 = mahaSquared(r, sInv)

			val xFilt: EkfState
			val pFilt: DoubleArray

			if (d2 > gate) {
				// Reject this measurement as outlier -> keep prediction
				xFilt = xPred
				pFilt = pPred
			} else {
				// K = P H^T S^-1   (4xm)
				val hTransposed = matTrans(hJacobian) // 4xm
				// Compute PHt (4xm)
				val pht = Array(4) { DoubleArray(m) }
				for (row in 0..3) for (col in 0 until m) {
					var ssum = 0.0
					for (k in 0..3) ssum += pPred[row*4+k] * hTransposed[k][col]
					pht[row][col] = ssum
				}
				// K = PHt * SInv (4xm)
				val kGain = Array(4) { DoubleArray(m) }
				for (row in 0..3) for (col in 0 until m) {
					var ssum = 0.0
					for (k in 0 until m) ssum += pht[row][k] * sInv[k][col]
					kGain[row][col] = ssum
				}

				// x = xPred + K r
				val dx = DoubleArray(4)
				for (row in 0..3) {
					var ssum = 0.0
					for (k in 0 until m) ssum += kGain[row][k] * r[k]
					dx[row] = ssum
				}
				xFilt = EkfState(
					x = xPred.x + dx[0],
					y = xPred.y + dx[1],
					vx = xPred.vx + dx[2],
					vy = xPred.vy + dx[3]
				)

				// p = (I - K H) pPred
				val kh = Array(4) { DoubleArray(4) }
				for (r0 in 0..3) for (c0 in 0..3) {
					var ssum = 0.0
					for (k in 0 until m) ssum += kGain[r0][k] * hJacobian[k][c0]
					kh[r0][c0] = ssum
				}
				val iMinusKh = Array(4) { r0 -> DoubleArray(4) { c0 -> (if (r0 == c0) 1.0 else 0.0) - kh[r0][c0] } }
				// pFilt = (I-KH) pPred
				val outP = DoubleArray(16)
				for (r0 in 0..3) for (c0 in 0..3) {
					var ssum = 0.0
					for (k in 0..3) ssum += iMinusKh[r0][k] * pPred[k*4+c0]
					outP[r0*4+c0] = ssum
				}
				pFilt = outP
			}

			steps += FilterStep(
				tMillis = t,
				xPred = xPred,
				pPred = pPred,
				xFilt = xFilt,
				pFilt = pFilt,
				f = f
			)

			x = xFilt
			p = pFilt
		}

		// RTS smoother (uses stored f, pPred, pFilt)
		val smoothed = MutableList(steps.size) { steps[it].xFilt }
		var ps = steps.last().pFilt

		for (k in steps.size - 2 downTo 0) {
			val stepK = steps[k]
			val stepK1 = steps[k + 1]

			val pk = stepK.pFilt
			val pk1Pred = stepK1.pPred
			val fk1 = stepK1.f

			// Compute smoother gain: ck = pk f^T (pk+1_pred)^-1
			// We’ll invert 4x4 with a simple Gauss-Jordan (since it’s only 4x4)
			val pkfTranspose = mat4Mul(pk, mat4Transpose(fk1))
			val invPk1Pred = inv4GaussJordan(pk1Pred)

			val ck = mat4Mul(pkfTranspose, invPk1Pred)

			// xs = xf + ck (x_{k+1}^s - x_{k+1}^pred)
			val xk = stepK.xFilt
			val xk1s = smoothed[k + 1]
			val xk1pred = stepK1.xPred
			val diff = doubleArrayOf(
				xk1s.x - xk1pred.x,
				xk1s.y - xk1pred.y,
				xk1s.vx - xk1pred.vx,
				xk1s.vy - xk1pred.vy
			)
			val corr = mat4Vec(ck, diff)
			val xks = EkfState(
				x = xk.x + corr[0],
				y = xk.y + corr[1],
				vx = xk.vx + corr[2],
				vy = xk.vy + corr[3]
			)
			smoothed[k] = xks

			// ps = pk + ck (ps_{k+1} - pk+1_pred) ck^T
			val psNext = ps
			val middle = mat4Sub(psNext, pk1Pred)
			val psNew = mat4Add(pk, mat4Mul(mat4Mul(ck, middle), mat4Transpose(ck)))
			ps = psNew
		}

		return smoothed to origin
	}

	private fun inv4GaussJordan(a: DoubleArray): DoubleArray {
		// 4x4 inversion via Gauss-Jordan; A row-major
		val m = Array(4) { DoubleArray(8) }
		for (r in 0..3) {
			for (c in 0..3) m[r][c] = a[r*4+c]
			for (c in 0..3) m[r][4+c] = if (r == c) 1.0 else 0.0
		}
		for (col in 0..3) {
			// pivot
			var pivotRow = col
			var maxAbs = abs(m[col][col])
			for (r in col+1..3) {
				val v = abs(m[r][col])
				if (v > maxAbs) { maxAbs = v; pivotRow = r }
			}
			require(maxAbs > 1e-12) { "Singular 4x4" }
			if (pivotRow != col) {
				val tmp = m[col]; m[col] = m[pivotRow]; m[pivotRow] = tmp
			}
			val piv = m[col][col]
			for (c in col until 8) m[col][c] /= piv
			for (r in 0..3) {
				if (r == col) continue
				val f = m[r][col]
				for (c in col until 8) m[r][c] -= f * m[col][c]
			}
		}
		val inv = DoubleArray(16)
		for (r in 0..3) for (c in 0..3) inv[r*4+c] = m[r][4+c]
		return inv
	}
}
