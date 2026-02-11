package com.hollybike.hollybike.tracking

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.hollybike.hollybike.MainActivity
import com.hollybike.hollybike.R
import com.hollybike.hollybike.realtime.RealtimeForegroundService
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import android.os.Handler
import android.os.Looper

class TrackingForegroundService : Service() {

	companion object {
		private const val CHANNEL_ID = "tracking_channel"
		private const val NOTIF_ID = 444

		const val EXTRA_TOKEN = "token"
		const val EXTRA_HOST = "host"
		const val EXTRA_EVENT_ID = "eventId"
		private const val DART_ENTRYPOINT = "locationServiceMain"
		private const val LOC_CHANNEL = "com.hollybike/location_service"   // from service Dart
		private const val UI_BRIDGE_CHANNEL = "com.hollybike/location_bridge" // to UI Dart
	}

	private var engine: FlutterEngine? = null
	private var fromServiceChannel: MethodChannel? = null

	override fun onCreate() {
		super.onCreate()
		ensureChannel()

		val notif = NotificationCompat.Builder(this, CHANNEL_ID)
			.setSmallIcon(R.drawable.ic_stat_hollybike)
			.setContentTitle("HollyBike")
			.setContentText("Localisation en arrière-plan active")
			.setOngoing(true)
			.setPriority(NotificationCompat.PRIORITY_LOW)
			.build()
		startForeground(NOTIF_ID, notif)

		val loader = FlutterInjector.instance().flutterLoader()
		loader.startInitialization(applicationContext)
		loader.ensureInitializationComplete(applicationContext, null)

		engine = FlutterEngine(this)
		try {
			val registrant = Class.forName("io.flutter.plugins.GeneratedPluginRegistrant")
			registrant.getDeclaredMethod("registerWith", FlutterEngine::class.java).invoke(null, engine)
		} catch (_: Exception) {}

		val entrypoint = DartExecutor.DartEntrypoint(loader.findAppBundlePath(), DART_ENTRYPOINT)
		engine!!.dartExecutor.executeDartEntrypoint(entrypoint)

		// 👇 Receive 'position' from the headless Dart (service engine)
		fromServiceChannel = MethodChannel(engine!!.dartExecutor.binaryMessenger, LOC_CHANNEL)
		fromServiceChannel!!.setMethodCallHandler { call, result ->
			if (call.method == "position") {
				val args = call.arguments  // Map<String, Any?>
				// Forward to UI engine if it's alive
				MainActivity.uiMessenger?.let { messenger ->
					MethodChannel(messenger, UI_BRIDGE_CHANNEL).invokeMethod("position", args)
				}
				result.success(null)
			} else {
				result.notImplemented()
			}
		}
	}

	override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
		val token = intent?.getStringExtra(EXTRA_TOKEN) ?: ""
		val host  = intent?.getStringExtra(EXTRA_HOST) ?: ""
		val eventId  = intent?.getIntExtra(EXTRA_EVENT_ID, 0) ?: ""
		fromServiceChannel?.invokeMethod("start", mapOf("token" to token, "host" to host, "eventId" to eventId))
		return START_STICKY
	}

	override fun onDestroy() {
		try {
			fromServiceChannel?.invokeMethod("stop", null)
		} catch (_: Exception) {}

		Handler(Looper.getMainLooper()).postDelayed({
			try { engine?.destroy() } catch (_: Exception) {}
			engine = null
			fromServiceChannel = null
		}, 1200)

		super.onDestroy()
	}

	override fun onBind(intent: Intent?): IBinder? = null

	private fun ensureChannel() {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val nm = getSystemService(NotificationManager::class.java)
			if (nm.getNotificationChannel(CHANNEL_ID) == null) {
				nm.createNotificationChannel(NotificationChannel(CHANNEL_ID, "Location tracking", NotificationManager.IMPORTANCE_LOW))
			}
		}
	}
}