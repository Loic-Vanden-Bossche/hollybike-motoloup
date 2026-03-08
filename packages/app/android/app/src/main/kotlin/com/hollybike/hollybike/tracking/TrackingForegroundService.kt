package com.hollybike.hollybike.tracking

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.hollybike.hollybike.MainActivity
import com.hollybike.hollybike.R
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
		const val EXTRA_TRACKING_EVENT_ID = "tracking_event_id"
		private const val DART_ENTRYPOINT = "locationServiceMain"
		private const val LOC_CHANNEL = "com.hollybike/location_service"
		private const val UI_BRIDGE_CHANNEL = "com.hollybike/location_bridge"
	}

	private var engine: FlutterEngine? = null
	private var fromServiceChannel: MethodChannel? = null

	// Stored so updateNotification() can mutate and re-post without rebuilding from scratch.
	private lateinit var notificationManager: NotificationManager
	private lateinit var notificationBuilder: NotificationCompat.Builder

	override fun onCreate() {
		super.onCreate()
		ensureChannel()

		notificationManager = getSystemService(NotificationManager::class.java)
		notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
			.setSmallIcon(R.drawable.ic_stat_hollybike)
			.setContentTitle("HollyBike")
			.setContentText("Localisation en arrière-plan active")
			// setOngoing(true) prevents the user from swiping the notification away.
			// Note: on Android 14+ the OS may still allow a temporary dismiss via
			// long-press — this is system policy and cannot be overridden by apps.
			.setOngoing(true)
			.setPriority(NotificationCompat.PRIORITY_LOW)

		startForeground(NOTIF_ID, notificationBuilder.build())

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

		fromServiceChannel = MethodChannel(engine!!.dartExecutor.binaryMessenger, LOC_CHANNEL)
		fromServiceChannel!!.setMethodCallHandler { call, result ->
			when (call.method) {
				"position" -> {
					// Forward raw position to the UI engine if it's alive.
					val args = call.arguments
					MainActivity.uiMessenger?.let { messenger ->
						MethodChannel(messenger, UI_BRIDGE_CHANNEL).invokeMethod("position", args)
					}
					result.success(null)
				}
				"updateNotification" -> {
					val args = call.arguments as? Map<*, *>
					val speed = (args?.get("speed") as? Double) ?: 0.0
					val distance = (args?.get("distance") as? Double) ?: 0.0
					updateNotification(speed, distance)
					result.success(null)
				}
				else -> result.notImplemented()
			}
		}
	}

	override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
		val token = intent?.getStringExtra(EXTRA_TOKEN) ?: ""
		val host  = intent?.getStringExtra(EXTRA_HOST) ?: ""
		val eventId = intent?.getIntExtra(EXTRA_EVENT_ID, 0) ?: 0

		// Attach a tap action to the notification so the user lands on the event
		// details page when they tap it.  Uses FLAG_ACTIVITY_SINGLE_TOP so that
		// if the app is already in the foreground, onNewIntent is called rather
		// than creating a new Activity instance.
		val tapIntent = Intent(this, MainActivity::class.java).apply {
			flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
			putExtra(EXTRA_TRACKING_EVENT_ID, eventId)
		}
		val pendingIntent = PendingIntent.getActivity(
			this,
			NOTIF_ID,
			tapIntent,
			PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
		)
		notificationBuilder.setContentIntent(pendingIntent)
		notificationManager.notify(NOTIF_ID, notificationBuilder.build())

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

	private fun updateNotification(speed: Double, distance: Double) {
		val speedStr = "${speed.toInt()} km/h"
		val distanceStr = "${String.format("%.1f", distance).replace('.', ',')} km"
		notificationBuilder.setContentText("$speedStr  •  $distanceStr")
		notificationManager.notify(NOTIF_ID, notificationBuilder.build())
	}

	private fun ensureChannel() {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val nm = getSystemService(NotificationManager::class.java)
			if (nm.getNotificationChannel(CHANNEL_ID) == null) {
				nm.createNotificationChannel(NotificationChannel(CHANNEL_ID, "Location tracking", NotificationManager.IMPORTANCE_LOW))
			}
		}
	}
}
