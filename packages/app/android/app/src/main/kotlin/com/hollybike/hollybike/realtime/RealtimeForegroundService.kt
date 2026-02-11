package com.hollybike.hollybike.realtime

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service

import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.hollybike.hollybike.R
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel

class RealtimeForegroundService : Service() {

	companion object {
		const val CHANNEL_ID = "realtime_channel"
		const val NOTIF_ID = 777
		const val EXTRA_TOKEN = "token"
		const val EXTRA_HOST = "host"
		const val METHOD_CHANNEL = "com.hollybike/realtime_service"
		private const val DART_ENTRYPOINT = "realtimeServiceMain"
	}

	private var engine: FlutterEngine? = null
	private var channel: MethodChannel? = null

	override fun onCreate() {
		super.onCreate()
		ensureChannel(CHANNEL_ID, "Live updates", NotificationManager.IMPORTANCE_LOW)

		val notif = NotificationCompat.Builder(this, CHANNEL_ID)
			.setSmallIcon(R.drawable.ic_stat_hollybike)
			.setContentTitle("HollyBike")
			.setContentText("Live updates actives")
			.setOngoing(true)
			.setPriority(NotificationCompat.PRIORITY_LOW)
			.build()
		startForeground(NOTIF_ID, notif)

		val loader = FlutterInjector.instance().flutterLoader()
		loader.startInitialization(applicationContext)
		loader.ensureInitializationComplete(applicationContext, null)

		engine = FlutterEngine(this)
		registerPlugins(engine!!)
		val entrypoint = DartExecutor.DartEntrypoint(loader.findAppBundlePath(), DART_ENTRYPOINT)
		engine!!.dartExecutor.executeDartEntrypoint(entrypoint)
		channel = MethodChannel(engine!!.dartExecutor.binaryMessenger, METHOD_CHANNEL)
	}

	override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
		val token = intent?.getStringExtra(EXTRA_TOKEN) ?: ""
		val host  = intent?.getStringExtra(EXTRA_HOST) ?: ""
		channel?.invokeMethod("start", mapOf("token" to token, "host" to host))
		return START_STICKY
	}

	override fun onDestroy() {
		channel?.invokeMethod("stop", null)
		engine?.destroy()
		engine = null
		channel = null
		super.onDestroy()
	}

	override fun onBind(intent: Intent?): IBinder? = null

	private fun ensureChannel(id: String, name: String, importance: Int) {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val nm = getSystemService(NotificationManager::class.java)
			if (nm.getNotificationChannel(id) == null) {
				nm.createNotificationChannel(NotificationChannel(id, name, importance))
			}
		}
	}

	private fun registerPlugins(engine: FlutterEngine) {
		try {
			val registrant = Class.forName("io.flutter.plugins.GeneratedPluginRegistrant")
			val method = registrant.getDeclaredMethod("registerWith", FlutterEngine::class.java)
			method.invoke(null, engine)
		} catch (_: Exception) { }
	}
}
