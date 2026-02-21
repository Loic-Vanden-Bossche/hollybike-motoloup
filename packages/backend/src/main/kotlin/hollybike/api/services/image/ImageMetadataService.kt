/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.image

import hollybike.api.types.event.image.TImageMetadata
import kotlin.time.Instant
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.bytesource.ByteSource
import org.apache.commons.imaging.common.RationalNumber
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants
import org.apache.commons.imaging.formats.tiff.constants.TiffTagConstants
import org.apache.commons.imaging.formats.tiff.taginfos.TagInfo
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.util.Locale
import java.text.SimpleDateFormat

class ImageMetadataService {
	private fun getValueFromCoordinates(data: ByteArray, tag: TagInfo, refTag: TagInfo): Double? {
		return try {
			val metadata = Imaging.getMetadata(data)

			if (metadata is JpegImageMetadata) {
				val gpsInfo = metadata.findExifValueWithExactMatch(tag) ?: return null

				val gpsValue = (gpsInfo.value as? Array<*>)
					?.filterIsInstance<RationalNumber>()
					?.takeIf { it.size >= 3 }
					?: return null
				val gpsRef = metadata.findExifValueWithExactMatch(refTag) ?: return null
				val value = gpsValue[0].toDouble() + gpsValue[1].toDouble() / 60 + gpsValue[2].toDouble() / 3600

				return if (gpsRef.value == "S" || gpsRef.value == "W") -value else value
			}
			null
		} catch (e: IOException) {
			e.printStackTrace()
			null
		}
	}

	private fun getLatitudeFromExif(data: ByteArray): Double? {
		return getValueFromCoordinates(
			data,
			GpsTagConstants.GPS_TAG_GPS_LATITUDE,
			GpsTagConstants.GPS_TAG_GPS_LATITUDE_REF
		)
	}

	private fun getLongitudeFromExif(data: ByteArray): Double? {
		return getValueFromCoordinates(
			data,
			GpsTagConstants.GPS_TAG_GPS_LONGITUDE,
			GpsTagConstants.GPS_TAG_GPS_LONGITUDE_REF
		)
	}

	private fun getAltitudeFromExif(data: ByteArray): Double? {
		return try {
			val metadata = Imaging.getMetadata(data) ?: return null

			if (metadata is JpegImageMetadata) {
				val gpsInfo = metadata.findExifValueWithExactMatch(GpsTagConstants.GPS_TAG_GPS_ALTITUDE) ?: return null
				val gpsValue = gpsInfo.value as RationalNumber

				return gpsValue.toDouble()
			}
			null
		} catch (e: IOException) {
			e.printStackTrace()
			null
		}
	}

	private fun getTakenTimeFromExif(data: ByteArray): Instant? {
		return try {
			val metadata = Imaging.getMetadata(data) ?: return null

			if (metadata is JpegImageMetadata) {
				val gpsInfo = metadata.findExifValue(TiffTagConstants.TIFF_TAG_DATE_TIME) ?: return null

				val gpsValue = gpsInfo.value as String
				val test = SimpleDateFormat("yyyy:MM:dd HH:mm:ss", Locale.US).parse(gpsValue)

				return Instant.fromEpochMilliseconds(test.time)
			}
			null
		} catch (e: IOException) {
			e.printStackTrace()
			null
		}
	}

	fun removeExifData(inputData: ByteArray): ByteArray {
		try {
			val inputStream = ByteArrayInputStream(inputData)
			val byteSource = ByteSource.inputStream(inputStream, null)

			val outputStream = ByteArrayOutputStream()

			val exifRewriter = ExifRewriter()
			exifRewriter.removeExifMetadata(byteSource, outputStream)

			return outputStream.toByteArray()
		} catch (e: Exception) {
			e.printStackTrace()
			println("Failed to remove EXIF data: ${e.message}")
			return inputData
		}
	}

	fun getImageMetadata(data: ByteArray): TImageMetadata {
		val latitude = getLatitudeFromExif(data)
		val longitude = getLongitudeFromExif(data)
		val altitude = getAltitudeFromExif(data)
		val takenTime = getTakenTimeFromExif(data)

		val position = if (latitude != null && longitude != null) {
			TImageMetadata.Position(
				latitude = latitude,
				longitude = longitude,
				altitude = altitude
			)
		} else null

		return TImageMetadata(
			position = position,
			takenDateTime = takenTime,
		)
	}

	fun getImageDimensions(data: ByteArray): Pair<Int, Int> {
		parsePngDimensions(data)?.let { return it }
		parseJpegDimensions(data)?.let { return it }

		return Pair(0, 0)
	}

	private fun parsePngDimensions(data: ByteArray): Pair<Int, Int>? {
		if (data.size < 24) return null
		val pngHeader = byteArrayOf(
			0x89.toByte(), 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
		)
		if (!data.copyOfRange(0, 8).contentEquals(pngHeader)) return null
		val width = ((data[16].toInt() and 0xFF) shl 24) or
			((data[17].toInt() and 0xFF) shl 16) or
			((data[18].toInt() and 0xFF) shl 8) or
			(data[19].toInt() and 0xFF)
		val height = ((data[20].toInt() and 0xFF) shl 24) or
			((data[21].toInt() and 0xFF) shl 16) or
			((data[22].toInt() and 0xFF) shl 8) or
			(data[23].toInt() and 0xFF)
		return if (width > 0 && height > 0) Pair(width, height) else null
	}

	private fun parseJpegDimensions(data: ByteArray): Pair<Int, Int>? {
		if (data.size < 4) return null
		if ((data[0].toInt() and 0xFF) != 0xFF || (data[1].toInt() and 0xFF) != 0xD8) return null

		var i = 2
		while (i + 9 < data.size) {
			if ((data[i].toInt() and 0xFF) != 0xFF) {
				i++
				continue
			}
			while (i < data.size && (data[i].toInt() and 0xFF) == 0xFF) i++
			if (i >= data.size) break

			val marker = data[i].toInt() and 0xFF
			i++

			if (marker == 0xD8 || marker == 0xD9 || (marker in 0xD0..0xD7)) continue
			if (i + 1 >= data.size) break

			val length = ((data[i].toInt() and 0xFF) shl 8) or (data[i + 1].toInt() and 0xFF)
			if (length < 2 || i + length > data.size) break

			val isSof = marker in setOf(
				0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7,
				0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF,
			)
			if (isSof && length >= 7) {
				val height = ((data[i + 3].toInt() and 0xFF) shl 8) or (data[i + 4].toInt() and 0xFF)
				val width = ((data[i + 5].toInt() and 0xFF) shl 8) or (data[i + 6].toInt() and 0xFF)
				return if (width > 0 && height > 0) Pair(width, height) else null
			}

			i += length
		}
		return null
	}
}


