package hollybike.api.utils

import kotlin.math.*

object AccelPreprocess {

	private const val G = 9.80665

	data class Vec3(var x: Double, var y: Double, var z: Double) {
		fun norm(): Double = sqrt(x*x + y*y + z*z)
		operator fun minus(o: Vec3) = Vec3(x - o.x, y - o.y, z - o.z)
		operator fun plus(o: Vec3) = Vec3(x + o.x, y + o.y, z + o.z)
		operator fun times(k: Double) = Vec3(x * k, y * k, z * k)
	}

	data class AccelMetrics(
		val linMag: Double,   // m/s^2
		val gForce: Double,   // unitless
		val jerk: Double      // m/s^3 (optional; 0 if not computable)
	)

	/**
	 * Gravity removal via low-pass on raw accel vector:
	 * gHat(t) = alpha * gHat(t-1) + (1-alpha) * aRaw(t)
	 *
	 * alpha derived from time constant tau:
	 * alpha = tau / (tau + dt)
	 *
	 * Typical tau for gravity: 0.6s to 1.0s
	 */
	fun computeLinearAccelMetrics(
		samples: List<PositionSample>,
		gravityTauSeconds: Double = 0.8,
		linLowPassTauSeconds: Double = 0.15,  // denoise linear magnitude a bit
		spikeClampMS2: Double = 35.0          // clamp absurd spikes (≈3.6g); tune per sport
	): List<AccelMetrics?> {

		if (samples.isEmpty()) return emptyList()

		var gHat: Vec3? = null
		var prevLinMagSmoothed: Double? = null
		var prevTime: Long? = null

		val out = ArrayList<AccelMetrics?>(samples.size)

		for (i in samples.indices) {
			val s = samples[i]
			val ax = s.ax
			val ay = s.ay
			val az = s.az

			// If accel missing, propagate null (or you can interpolate)
			if (ax == null || ay == null || az == null || !ax.isFinite() || !ay.isFinite() || !az.isFinite()) {
				out += null
				prevTime = s.timeMillis
				continue
			}

			val aRaw = Vec3(ax, ay, az)

			val dt = if (prevTime == null) 0.02 else max(0.005, (s.timeMillis - prevTime).toDouble() / 1000.0)
			prevTime = s.timeMillis

			// Update gravity estimate
			val alphaG = gravityTauSeconds / (gravityTauSeconds + dt)
			gHat = if (gHat == null) aRaw else (gHat * alphaG + aRaw * (1.0 - alphaG))

			// Remove gravity
			val aLin = aRaw - gHat

			// Clamp spikes component-wise (simple robustifier)
			aLin.x = aLin.x.coerceIn(-spikeClampMS2, spikeClampMS2)
			aLin.y = aLin.y.coerceIn(-spikeClampMS2, spikeClampMS2)
			aLin.z = aLin.z.coerceIn(-spikeClampMS2, spikeClampMS2)

			// Magnitude of linear acceleration
			var linMag = aLin.norm()

			// Light low-pass on magnitude to reduce jitter
			val alphaLin = linLowPassTauSeconds / (linLowPassTauSeconds + dt)
			val linMagSmoothed = if (prevLinMagSmoothed == null) linMag
			else alphaLin * prevLinMagSmoothed + (1.0 - alphaLin) * linMag
			prevLinMagSmoothed = linMagSmoothed
			linMag = linMagSmoothed

			// Jerk = d(linMag)/dt (with smoothing already applied)
			val jerk = if (i == 0) 0.0 else {
				val prev = out.lastOrNull()?.linMag
				if (prev == null) 0.0 else (linMag - prev) / dt
			}

			out += AccelMetrics(
				linMag = linMag,
				gForce = linMag / G,
				jerk = jerk
			)
		}

		return out
	}
}
