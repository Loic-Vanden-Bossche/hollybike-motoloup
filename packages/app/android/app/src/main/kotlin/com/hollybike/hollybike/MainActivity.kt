package com.hollybike.hollybike

import android.app.ForegroundServiceStartNotAllowedException
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.media.ExifInterface
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.provider.OpenableColumns
import android.util.Log
import androidx.core.view.WindowCompat
import com.hollybike.hollybike.tracking.TrackingForegroundService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

private const val NAV_INTENT_CHANNEL = "com.hollybike/nav_intent"

class MainActivity : FlutterActivity() {
	private val channel = "com.hollybike/fgs_control"
	private val mediaPickerChannel = "com.hollybike/media_picker"
	private val mediaPickerLogTag = "NativeMediaPicker"
	private val singleMediaPickerRequestCode = 1101
	private val multipleMediaPickerRequestCode = 1102
	private var isUiResumed = false
	private var pendingLocationStart: Intent? = null
	private var pendingMediaPickerResult: MethodChannel.Result? = null

	// Nav intent: delivers the tracking event ID to Flutter when the user taps
	// the foreground-service notification.  pendingNavEventId holds the value
	// for cold-start taps (app was not running); warm-start taps are pushed
	// directly via navChannel.invokeMethod once the channel is ready.
	private var navChannel: MethodChannel? = null
	private var pendingNavEventId: Int? = null
	private var pendingNavMethod: String = "openTrackingEvent"

	companion object {
		@JvmStatic
		var uiMessenger: BinaryMessenger? = null
	}

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		WindowCompat.setDecorFitsSystemWindows(window, false)
		// Cold-start tap: the launch intent may carry the tracking event ID.
		val coldEventId = intent
			?.getIntExtra(TrackingForegroundService.EXTRA_TRACKING_EVENT_ID, -1)
			?.takeIf { it != -1 }
		pendingNavEventId = coldEventId
		if (coldEventId != null) {
			val autoTerminate = intent?.getBooleanExtra(TrackingForegroundService.EXTRA_AUTO_TERMINATE, false) ?: false
			pendingNavMethod = if (autoTerminate) "terminateTrackingJourney" else "openTrackingEvent"
		}
	}

	// Warm-start tap: the activity is already running; Android calls onNewIntent
	// instead of onCreate because FLAG_ACTIVITY_SINGLE_TOP is set on the PendingIntent.
	override fun onNewIntent(intent: Intent) {
		super.onNewIntent(intent)
		setIntent(intent)
		val eventId = intent
			.getIntExtra(TrackingForegroundService.EXTRA_TRACKING_EVENT_ID, -1)
			.takeIf { it != -1 } ?: return

		val autoTerminate = intent.getBooleanExtra(TrackingForegroundService.EXTRA_AUTO_TERMINATE, false)
		val method = if (autoTerminate) "terminateTrackingJourney" else "openTrackingEvent"

		// Push straight to Dart if the channel is ready, otherwise hold for pull.
		navChannel?.invokeMethod(method, eventId)
			?: run {
				pendingNavEventId = eventId
				pendingNavMethod = method
			}
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		uiMessenger = flutterEngine.dartExecutor.binaryMessenger

		// Flutter calls getPendingNavEventId once on startup to handle cold-start
		// notification taps.  Warm-start taps are pushed via invokeMethod in onNewIntent.
		navChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NAV_INTENT_CHANNEL)
		navChannel!!.setMethodCallHandler { call, result ->
			when (call.method) {
				"getPendingNavIntent" -> {
					if (pendingNavEventId != null) {
						result.success(mapOf("eventId" to pendingNavEventId, "method" to pendingNavMethod))
					} else {
						result.success(null)
					}
					pendingNavEventId = null
					pendingNavMethod = "openTrackingEvent"
				}
				else -> result.notImplemented()
			}
		}

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
			.setMethodCallHandler { call, result ->
				when (call.method) {
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

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mediaPickerChannel)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"pickGalleryImages" -> {
						if (pendingMediaPickerResult != null) {
							result.error("picker_busy", "A media picker request is already in progress.", null)
							return@setMethodCallHandler
						}

						pendingMediaPickerResult = result
						val multiple = call.argument<Boolean>("multiple") == true
						launchMediaPicker(multiple)
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

	@Deprecated("Deprecated in Java")
	override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
		super.onActivityResult(requestCode, resultCode, data)

		if (requestCode != singleMediaPickerRequestCode && requestCode != multipleMediaPickerRequestCode) {
			return
		}

		val result = pendingMediaPickerResult ?: return
		pendingMediaPickerResult = null

		if (resultCode != RESULT_OK || data == null) {
			result.success(emptyList<Map<String, Any?>>())
			return
		}

		val uris = extractUris(data)
		result.success(uris.mapNotNull(::buildPickedMediaPayload))
	}

	private fun drainPendingForegroundStarts() {
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

	private fun launchMediaPicker(multiple: Boolean) {
		val intent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI).apply {
			type = "image/*"
			putExtra(Intent.EXTRA_ALLOW_MULTIPLE, multiple)
			addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
		}

		startActivityForResult(
			Intent.createChooser(intent, null),
			if (multiple) multipleMediaPickerRequestCode else singleMediaPickerRequestCode,
		)
	}

	private fun extractUris(data: Intent): List<Uri> {
		val uris = mutableListOf<Uri>()
		data.data?.let(uris::add)

		val clipData = data.clipData
		if (clipData != null) {
			for (index in 0 until clipData.itemCount) {
				clipData.getItemAt(index).uri?.let(uris::add)
			}
		}

		return uris.distinct()
	}

	private fun buildPickedMediaPayload(uri: Uri): Map<String, Any?>? {
		return try {
			val copiedFile = copyUriToCache(uri) ?: return null
			val exifLocation = readExifLocation(uri)
			if (exifLocation == null) {
				Log.d(mediaPickerLogTag, "EXIF GPS missing for uri=$uri copiedPath=${copiedFile.absolutePath}")
			} else {
				Log.d(
					mediaPickerLogTag,
					"EXIF GPS present for uri=$uri copiedPath=${copiedFile.absolutePath} lat=${exifLocation.first} lng=${exifLocation.second}",
				)
			}
			hashMapOf(
				"path" to copiedFile.absolutePath,
				"latitude" to exifLocation?.first,
				"longitude" to exifLocation?.second,
			)
		} catch (error: Exception) {
			Log.e(mediaPickerLogTag, "Failed to build picked media payload for uri=$uri", error)
			null
		}
	}

	private fun copyUriToCache(uri: Uri): File? {
		val fileName = queryDisplayName(uri) ?: "picked_${System.currentTimeMillis()}.jpg"
		val pickerCacheDir = File(cacheDir, "native_gallery_picker").apply { mkdirs() }
		val outputFile = File(pickerCacheDir, "${System.currentTimeMillis()}_$fileName")

		contentResolver.openInputStream(uri)?.use { input ->
			FileOutputStream(outputFile).use { output ->
				input.copyTo(output)
			}
		} ?: return null

		return outputFile
	}

	private fun queryDisplayName(uri: Uri): String? {
		val projection = arrayOf(OpenableColumns.DISPLAY_NAME)
		val cursor: Cursor = contentResolver.query(uri, projection, null, null, null) ?: return null
		cursor.use {
			if (!it.moveToFirst()) {
				return null
			}

			val index = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
			if (index == -1) {
				return null
			}

			return it.getString(index)
		}
	}

	private fun readExifLocation(uri: Uri): Pair<Double, Double>? {
		val targetUri = requireOriginalUri(uri)
		readExifLocationFromUri(targetUri)?.let { return it }

		if (targetUri != uri) {
			Log.d(mediaPickerLogTag, "Falling back to picker uri for EXIF read: $uri")
			readExifLocationFromUri(uri)?.let { return it }
		}

		return null
	}

	private fun readExifLocationFromUri(uri: Uri): Pair<Double, Double>? {
		return try {
			contentResolver.openInputStream(uri)?.use { input ->
				val exif = ExifInterface(input)
				val latLong = FloatArray(2)
				if (exif.getLatLong(latLong)) {
					return Pair(latLong[0].toDouble(), latLong[1].toDouble())
				}
			}

			null
		} catch (error: Exception) {
			Log.d(mediaPickerLogTag, "EXIF read failed for uri=$uri", error)
			null
		}
	}

	private fun requireOriginalUri(uri: Uri): Uri {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
			return uri
		}

		return try {
			MediaStore.setRequireOriginal(uri)
		} catch (_: UnsupportedOperationException) {
			uri
		} catch (_: SecurityException) {
			uri
		}
	}
}
