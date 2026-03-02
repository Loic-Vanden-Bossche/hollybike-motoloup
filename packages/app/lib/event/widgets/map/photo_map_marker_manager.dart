/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hollybike/image/type/geolocated_event_image.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PhotoMapMarkerManager {
  static const _bubbleRadius = 100.0;
  static const _borderWidth = 6.0;
  static const _pointerHeight = 22.0;
  static const _canvasWidth = (_bubbleRadius + _borderWidth) * 2 + 12;
  static const _canvasHeight = _canvasWidth + _pointerHeight + 6;

  final PointAnnotationManager pointManager;
  final Color borderColor;

  PointAnnotation? _annotation;
  Uint8List? _fallbackIcon;
  int _requestId = 0;

  // Cache rendered bubble images by key to avoid re-downloading on swipe
  final Map<String, Uint8List> _bubbleCache = {};

  PhotoMapMarkerManager({
    required this.pointManager,
    required this.borderColor,
  });

  Future<void> init() async {
    _fallbackIcon = await _buildFallbackIcon(borderColor);
  }

  Future<void> showAt(GeolocatedEventImage image) async {
    // Stamp this request so stale downloads from rapid swipes are discarded.
    final requestId = ++_requestId;

    final icon = await _resolveIcon(image);

    // A newer request arrived while we were downloading — abort.
    if (requestId != _requestId) return;

    // Always delete + recreate: updating image on an existing annotation
    // is unreliable in the Mapbox Flutter SDK.
    final existing = _annotation;
    if (existing != null) {
      _annotation = null;
      await pointManager.delete(existing);
    }

    if (requestId != _requestId) return;

    _annotation = await pointManager.create(
      PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            image.position.longitude,
            image.position.latitude,
          ),
        ),
        image: icon,
        iconSize: 1.0,
        iconAnchor: IconAnchor.BOTTOM,
      ),
    );
  }

  Future<void> hide() async {
    final annotation = _annotation;
    if (annotation == null) return;
    await pointManager.delete(annotation);
    _annotation = null;
  }

  // ── Icon resolution ────────────────────────────────────────────────────────

  Future<Uint8List> _resolveIcon(GeolocatedEventImage image) async {
    final cached = _bubbleCache[image.key];
    if (cached != null) return cached;

    try {
      final response = await http
          .get(Uri.parse(image.url))
          .timeout(const Duration(seconds: 6));

      final codec = await ui.instantiateImageCodec(
        response.bodyBytes,
        targetWidth: ((_bubbleRadius) * 2).round(),
        targetHeight: ((_bubbleRadius) * 2).round(),
      );
      final frame = await codec.getNextFrame();
      final icon = await _buildBubbleIcon(frame.image);
      frame.image.dispose();

      _bubbleCache[image.key] = icon;
      return icon;
    } catch (_) {
      return _fallbackIcon ?? await _buildFallbackIcon(borderColor);
    }
  }

  // ── Bubble canvas drawing ──────────────────────────────────────────────────

  Future<Uint8List> _buildBubbleIcon(ui.Image photo) async {
    final cx = _canvasWidth / 2;
    final cy = (_canvasWidth / 2) + 3; // small top padding for shadow bleed

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Drop shadow
    canvas.drawCircle(
      Offset(cx, cy + 3),
      _bubbleRadius + _borderWidth,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // White border ring
    canvas.drawCircle(
      Offset(cx, cy),
      _bubbleRadius + _borderWidth,
      Paint()..color = Colors.white,
    );

    // Colored accent ring (thin, on top of white)
    canvas.drawCircle(
      Offset(cx, cy),
      _bubbleRadius + _borderWidth,
      Paint()
        ..color = borderColor.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Photo clipped to circle
    canvas.save();
    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCircle(center: Offset(cx, cy), radius: _bubbleRadius),
        ),
    );
    paintImage(
      canvas: canvas,
      rect: Rect.fromCircle(center: Offset(cx, cy), radius: _bubbleRadius),
      image: photo,
      fit: BoxFit.cover,
    );
    canvas.restore();

    // Pointer triangle (same white as the border ring)
    final tipX = cx;
    final tipY = cy + _bubbleRadius + _borderWidth + _pointerHeight;
    final baseY = cy + _bubbleRadius + _borderWidth - 2;
    final pointer = Path()
      ..moveTo(cx - 9, baseY)
      ..lineTo(cx + 9, baseY)
      ..lineTo(tipX, tipY)
      ..close();

    canvas.drawPath(
      pointer,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(pointer, Paint()..color = Colors.white);

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      _canvasWidth.round(),
      _canvasHeight.round(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  // ── Fallback camera icon (used before image loads or on error) ─────────────

  static Future<Uint8List> _buildFallbackIcon(Color color) async {
    const size = 56.0;
    final center = Offset(size / 2, size / 2);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawCircle(
      center.translate(0, 2),
      size / 2 - 2,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(center, size / 2 - 4, Paint()..color = color);
    canvas.drawCircle(
      center,
      size / 2 - 4,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.photo_camera_rounded.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: Icons.photo_camera_rounded.fontFamily,
          package: Icons.photo_camera_rounded.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.round(), size.round());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}
