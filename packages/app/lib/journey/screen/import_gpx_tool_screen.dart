/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class ImportGpxToolScreen extends StatefulWidget {
  final String url;
  final void Function(File) onGpxDownloaded;
  final void Function() onClose;

  const ImportGpxToolScreen({
    super.key,
    required this.url,
    required this.onGpxDownloaded,
    required this.onClose,
  });

  @override
  State<ImportGpxToolScreen> createState() => _ImportGpxToolScreenState();
}

class _ImportGpxToolScreenState extends State<ImportGpxToolScreen> {
  InAppWebViewController? _controller;

  bool _popped = false;
  bool _allowSystemPop = true;

  void _log(String msg) => debugPrint('[HollybikeWebView] $msg');

  Future<void> _refreshCanPop() async {
    final canGoBack = await _controller?.canGoBack() ?? false;
    if (!mounted) return;
    setState(() => _allowSystemPop = !canGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowSystemPop,
      onPopInvokedWithResult: (didPop, result) {
        if (_popped) return;

        // Non-async callback; wrap awaits if you have any.
        () async {
          if (didPop) {
            // Route actually popped → do cleanup
            _popped = true;
            _forceClose(); // make sure this doesn't pop again
            return;
          }

          // Navigator did NOT pop (because canPop was false) → drive WebView back
          final canGoBack = await _controller?.canGoBack() ?? false;
          if (canGoBack) {
            _controller?.goBack();
            // refresh flags after navigation
            Future.microtask(_refreshCanPop);
            return;
          }

          // No history but canPop was false (shouldn't happen often).
          // Fall back to forcing a route pop.
          _forceClose();
        }();
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              useOnDownloadStart: true,
              useShouldInterceptFetchRequest: true,
              javaScriptEnabled: true,
              incognito: false,
              clearCache: false,
              geolocationEnabled: true,
              mediaPlaybackRequiresUserGesture: true,
              isInspectable: false,
            ),

            onWebViewCreated: (controller) {
              _controller = controller;
              _refreshCanPop(); // initial state
              _log('WebView created for ${widget.url}');

              // JS -> Flutter logging bridge
              controller.addJavaScriptHandler(
                handlerName: 'log',
                callback: (args) async {
                  final msg = args.isNotEmpty ? '${args[0]}' : '';
                  _log('[JS] $msg');
                },
              );

              // GPX bridges (text and base64)
              controller.addJavaScriptHandler(
                handlerName: 'gpxText',
                callback: (args) async {
                  final text = (args.isNotEmpty ? args.first : '') as String? ?? '';
                  _log('Received gpxText, length=${text.length}');
                  if (!text.contains('<gpx')) return;
                  _onGpxDownloaded(context, writeTempFile(utf8.encode(text)));
                },
              );
              controller.addJavaScriptHandler(
                handlerName: 'gpxBase64',
                callback: (args) async {
                  final b64 = (args.isNotEmpty ? args.first : '') as String? ?? '';
                  _log('Received gpxBase64, length=${b64.length}');
                  if (b64.isEmpty) return;
                  final bytes = base64Decode(b64);
                  final maybeText = utf8.decode(bytes, allowMalformed: true);
                  if (!maybeText.contains('<gpx')) return;
                  _onGpxDownloaded(context, writeTempFile(bytes));
                },
              );
            },

            onGeolocationPermissionsShowPrompt: (controller, origin) async {
              _log('onGeolocationPermissionsShowPrompt origin=$origin');

              var status = await Permission.locationWhenInUse.status;
              if (!status.isGranted) {
                status = await Permission.locationWhenInUse.request();
                _log('Re-requested OS location permission: $status');
              }

              final allow = status.isGranted;
              _log('Granting geolocation to web origin=$origin -> $allow');

              return GeolocationPermissionShowPromptResponse(
                origin: origin,
                allow: allow,
                retain: true,
              );
            },

            onLoadStart: (controller, url) async {
              await _refreshCanPop();
              _log('onLoadStart: $url');

              await controller.evaluateJavascript(source: _earlyInjectorJs());
            },

            onUpdateVisitedHistory: (controller, url, androidIsReload) async {
              await _refreshCanPop();
            },

            onLoadStop: (controller, url) async {
              _log('onLoadStop: $url');
            },

            onConsoleMessage: (controller, consoleMessage) {
              _log('console[${consoleMessage.messageLevel}]: ${consoleMessage.message}');
            },

            onReceivedError: (controller, request, error) {
              _log('onReceivedError: url=${request.url} type=${error.type} desc=${error.description}');
            },

            onReceivedHttpError: (controller, request, errorResponse) {
              _log('onReceivedHttpError: ${request.url} status=${errorResponse.statusCode}');
            },

            onLoadResource: (controller, resource) {
              _log('onLoadResource: ${resource.url} ''start=${resource.startTime}ms dur=${resource.duration}ms');
            },

            shouldInterceptFetchRequest: (controller, request) async {
              final url = request.url.toString();
              _log('shouldInterceptFetchRequest: $url headers=${request.headers}');

              final isOpenrunnerFile =
                  url.startsWith("https://api.openrunner.com/api/v2/routes/") &&
                      url.endsWith("/export/gpx-track");

              if (isOpenrunnerFile) {
                _log('OpenRunner match. Fetching via Dart http...');
                final response = await http.get(
                  Uri.parse(url),
                  headers: {
                    'User-Agent': request.headers?['User-Agent'] ?? '',
                    'Accept': request.headers?['Accept'] ?? '',
                  },
                );

                _log('OpenRunner response: ${response.statusCode} len=${response.bodyBytes.length}');
                if (!response.body.contains('<gpx')) {
                  return Future.value(request);
                }

                if (context.mounted) {
                  _onGpxDownloaded(context, writeTempFile(response.bodyBytes));
                }
                return Future.value(null);
              }

              return Future.value(request);
            },

            onDownloadStartRequest: (controller, data) async {
              final requestUrl = data.url.toString();
              _log('onDownloadStartRequest: $requestUrl '
                  'mime=${data.mimeType} contentDisposition=${data.contentDisposition} '
                  'userAgent=${data.userAgent}');

              // data: URLs
              if (requestUrl.startsWith('data:text')) {
                _log('Handling data: URL');
                final cleanUrl = requestUrl.replaceAll(RegExp(r'data:text.*?,'), '');
                final decoded = Uri.decodeFull(cleanUrl);
                _log('data: length=${decoded.length}');
                if (!decoded.contains('<gpx')) return;
                _onGpxDownloaded(context, writeTempFile(utf8.encode(decoded)));
                return;
              }

              // blob: URLs -> DO NOT fetch (CSP). The early JS injector captures these blobs
              if (requestUrl.startsWith('blob:')) {
                _log('blob: URL detected. Relying on early JS capture. (CSP blocks fetch)');
                // Nothing to do here; the JS hook should have already sent gpxText/gpxBase64.
                await controller.evaluateJavascript(source: """
                  (function(){
                    window.__HB_log && window.__HB_log('Flutter pinged after blob download start');
                    if (window.__HB_tryEmitPendingBlob) window.__HB_tryEmitPendingBlob(${"jsonEncode(requestUrl)"});
                  })();
                """);
                return;
              }

              // Regular http/https
              final uri = Uri.parse(requestUrl);
              _log('Fetching via Dart http: $uri');
              final response = await http.get(
                uri,
                headers: {
                  if (data.userAgent != null) 'User-Agent': data.userAgent!,
                  if (data.mimeType != null) 'Accept': data.mimeType!,
                },
              );
              _log('HTTP response: ${response.statusCode} len=${response.bodyBytes.length}');
              if (!response.body.contains('<gpx')) return;

              if (context.mounted) {
                _onGpxDownloaded(context, writeTempFile(response.bodyBytes));
              }
            },
          ),
        ),
      ),
    );
  }

  /// Early JS injector: verbose logging + Blob capture BEFORE CSP can bite.
  String _earlyInjectorJs() {
    return r"""
(function() {
  try {
    const call = (...a) => {
      try { window.flutter_inappwebview.callHandler('log', a.join(' ')); } catch (_) {}
    };
    window.__HB_log = call;

    // Mirror console.* to Flutter
    ['log','warn','error','info','debug'].forEach(fn => {
      const orig = console[fn];
      console[fn] = function(...args) {
        try { window.flutter_inappwebview.callHandler('log', '[console.'+fn+'] ' + args.map(x => (''+x)).join(' ')); } catch(_) {}
        try { orig.apply(console, args); } catch(_) {}
      };
    });

    // Global error hooks
    window.addEventListener('error', e => {
      call('[window.error]', e.message, 'at', e.filename, e.lineno+':'+e.colno);
    });
    window.addEventListener('unhandledrejection', e => {
      call('[unhandledrejection]', (e && e.reason) ? (''+e.reason) : 'unknown');
    });

    // Log CSP if present
    try {
      const metas = Array.from(document.querySelectorAll('meta[http-equiv="Content-Security-Policy"]'));
      metas.forEach(m => call('[CSP]', m.getAttribute('content') || ''));
    } catch(_) {}

    // ---- Blob capture ----
    // Many sites do: const url = URL.createObjectURL(blob); a.href = url; a.download = ...
    // We hook createObjectURL to read the Blob directly (no fetch -> CSP-safe)
    const _createObjectURL = URL.createObjectURL.bind(URL);
    const _revoke = URL.revokeObjectURL.bind(URL);
    const pendingBlobs = new Map(); // objectURL -> Blob
    window.__HB_pendingBlobs = pendingBlobs;

    async function emitBlob(url, blob) {
      try {
        const type = blob && blob.type || '';
        call('[Blob]', 'url='+url, 'type='+type, 'size='+(blob && blob.size));
        // Try text first
        let text = '';
        try { text = await blob.text(); } catch(_) {}
        if (text && text.indexOf('<gpx') !== -1) {
          window.flutter_inappwebview.callHandler('gpxText', text);
          return;
        }
        // Fallback: base64
        try {
          const ab = await blob.arrayBuffer();
          const bytes = new Uint8Array(ab);
          let bin = '';
          for (let i = 0; i < bytes.length; i++) bin += String.fromCharCode(bytes[i]);
          const b64 = btoa(bin);
          window.flutter_inappwebview.callHandler('gpxBase64', b64);
        } catch (e2) {
          call('[Blob emit error]', ''+e2);
        }
      } catch (e) {
        call('[emitBlob error]', ''+e);
      }
    }

    URL.createObjectURL = function(blob) {
      const url = _createObjectURL(blob);
      try {
        pendingBlobs.set(url, blob);
        call('[createObjectURL]', url, 'type='+(blob && blob.type));
        // Opportunistically emit immediately; some pages never navigate to the blob
        emitBlob(url, blob);
      } catch(e) {
        call('[createObjectURL error]', ''+e);
      }
      return url;
    };

    URL.revokeObjectURL = function(url) {
      try { pendingBlobs.delete(url); } catch(_) {}
      return _revoke(url);
    };

    // Hook anchor clicks to log and try emitting
    (function(){
      const orig = HTMLAnchorElement.prototype.click;
      HTMLAnchorElement.prototype.click = function() {
        try {
          const href = this.getAttribute('href') || '';
          call('[a.click]', href);
          const b = pendingBlobs.get(href);
          if (b) emitBlob(href, b);
        } catch(_) {}
        return orig.apply(this, arguments);
      };
    })();

    // Exposed helper: try to emit a specific blob by URL (used from Dart on downloadStart)
    window.__HB_tryEmitPendingBlob = function(url) {
      try {
        const b = pendingBlobs.get(url);
        if (b) {
          call('[emitPending]', url);
          emitBlob(url, b);
        } else {
          call('[emitPending miss]', url);
        }
      } catch(e) {
        call('[emitPending error]', ''+e);
      }
    };

    call('[Injector ready]');
  } catch (e) {
    try { window.flutter_inappwebview.callHandler('log', '[Injector fatal] ' + e); } catch(_) {}
  }
})();
""";
  }

  Future<bool> canPopFromController() async {
    if (_controller == null) return false;
    return _controller!.canGoBack();
  }

  File writeTempFile(List<int> bytes) {
    final tempDir = Directory.systemTemp;
    final filePath = path.join(tempDir.path, 'hollybike-temp.gpx');
    final file = File(filePath);
    file.writeAsBytesSync(bytes);
    _log('Temp GPX written: $filePath (${bytes.length} bytes)');
    return file;
  }

  void _forceClose() {
    widget.onClose();
  }

  void _onGpxDownloaded(BuildContext context, File file) async {
    _log('GPX ready -> popping and invoking callback');

    _forceClose();

    widget.onGpxDownloaded(file);
  }
}