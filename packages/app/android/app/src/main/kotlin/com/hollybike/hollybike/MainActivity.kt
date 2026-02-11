package com.hollybike.hollybike

import android.app.ForegroundServiceStartNotAllowedException
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import com.hollybike.hollybike.realtime.RealtimeForegroundService
import com.hollybike.hollybike.tracking.TrackingForegroundService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channel = "com.hollybike/fgs_control"
	private var isUiResumed = false
	private var pendingRealtimeStart: Intent? = null
	private var pendingLocationStart: Intent? = null

	companion object {
		@JvmStatic
		var uiMessenger: BinaryMessenger? = null
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		uiMessenger = flutterEngine.dartExecutor.binaryMessenger

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"startRealtime" -> {
						val token = call.argument<String>("token") ?: ""
						val host = call.argument<String>("host") ?: ""
						val intent = Intent(this, RealtimeForegroundService::class.java)
							.putExtra(RealtimeForegroundService.EXTRA_TOKEN, token)
							.putExtra(RealtimeForegroundService.EXTRA_HOST, host)
						startForegroundServiceSafely(
							intent = intent,
							storePending = { pendingRealtimeStart = intent },
						)
						result.success(null)
					}

					"stopRealtime" -> {
						pendingRealtimeStart = null
						stopService(Intent(this, RealtimeForegroundService::class.java))
						result.success(null)
					}

					"startLocation" -> {
						val token = call.argument<String>("token") ?: ""
						val host = call.argument<String>("host") ?: ""
						val eventId = call.argument<Int>("eventId") ?: 0
						val intent = Intent(this, TrackingForegroundService::class.java)
							.putExtra(TrackingForegroundService.EXTRA_TOKEN, token)
							.putExtra(TrackingForegroundService.EXTRA_HOST, host)
							.putExtra(TrackingForegroundService.EXTRA_EVENT_ID, eventId)
						startForegroundServiceSafely(
							intent = intent,
							storePending = { pendingLocationStart = intent },
						)
						result.success(null)
					}

					"stopLocation" -> {
						pendingLocationStart = null
						stopService(Intent(this, TrackingForegroundService::class.java))
						result.success(null)
					}

					"hasManifestPermission" -> {
						val permission = call.argument<String>("permission")
						if (permission.isNullOrBlank()) {
							result.success(false)
						} else {
							result.success(hasManifestPermission(permission))
						}
					}

					else -> result.notImplemented()
				}
			}
	}

	override fun onResume() {
		super.onResume()
		isUiResumed = true
		drainPendingForegroundStarts()
	}

	override fun onPause() {
		isUiResumed = false
		super.onPause()
	}

	private fun drainPendingForegroundStarts() {
		pendingRealtimeStart?.let { intent ->
			pendingRealtimeStart = null
			startForegroundServiceSafely(
				intent = intent,
				storePending = { pendingRealtimeStart = intent },
			)
		}

		pendingLocationStart?.let { intent ->
			pendingLocationStart = null
			startForegroundServiceSafely(
				intent = intent,
				storePending = { pendingLocationStart = intent },
			)
		}
	}

	private fun startForegroundServiceSafely(
		intent: Intent,
		storePending: () -> Unit,
	) {
		try {
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !isUiResumed) {
				storePending()
				return
			}

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
				startForegroundService(intent)
			} else {
				startService(intent)
			}
		} catch (_: ForegroundServiceStartNotAllowedException) {
			storePending()
		} catch (_: IllegalStateException) {
			storePending()
		}
	}

	private fun hasManifestPermission(permission: String): Boolean {
		val requestedPermissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
			packageManager.getPackageInfo(
				packageName,
				PackageManager.PackageInfoFlags.of(PackageManager.GET_PERMISSIONS.toLong()),
			).requestedPermissions
		} else {
			@Suppress("DEPRECATION")
			packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS).requestedPermissions
		}

		return requestedPermissions?.contains(permission) == true
	}
}
