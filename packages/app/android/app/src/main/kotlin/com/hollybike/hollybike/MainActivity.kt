package com.hollybike.hollybike

import android.content.Intent
import android.os.Build
import android.content.pm.PackageManager
import com.hollybike.hollybike.realtime.RealtimeForegroundService
import com.hollybike.hollybike.tracking.TrackingForegroundService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "com.hollybike/fgs_control"

	companion object {
		@JvmStatic var uiMessenger: BinaryMessenger? = null   // 👈 expose UI engine messenger
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		uiMessenger = flutterEngine.dartExecutor.binaryMessenger   // 👈 keep a ref

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"startRealtime" -> {
						val token = call.argument<String>("token") ?: ""
						val host  = call.argument<String>("host") ?: ""
						val i = Intent(this, RealtimeForegroundService::class.java)
							.putExtra(RealtimeForegroundService.EXTRA_TOKEN, token)
							.putExtra(RealtimeForegroundService.EXTRA_HOST, host)
						if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
							startForegroundService(i)
						}
						result.success(null)
					}
					"stopRealtime" -> {
						stopService(Intent(this, RealtimeForegroundService::class.java))
						result.success(null)
					}
					"startLocation" -> {
						val token = call.argument<String>("token") ?: ""
						val host  = call.argument<String>("host") ?: ""
						val eventId  = call.argument<Int>("eventId") ?: ""
						val i = Intent(this, TrackingForegroundService::class.java)
							.putExtra(TrackingForegroundService.EXTRA_TOKEN, token)
							.putExtra(TrackingForegroundService.EXTRA_HOST, host)
							.putExtra(TrackingForegroundService.EXTRA_EVENT_ID, eventId)
						if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
							startForegroundService(i)
						}
						result.success(null)
					}
					"stopLocation" -> {
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

	private fun hasManifestPermission(permission: String): Boolean {
		val requestedPermissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
			packageManager.getPackageInfo(
				packageName,
				PackageManager.PackageInfoFlags.of(PackageManager.GET_PERMISSIONS.toLong())
			).requestedPermissions
		} else {
			@Suppress("DEPRECATION")
			packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS).requestedPermissions
		}

		return requestedPermissions?.contains(permission) == true
	}
}
