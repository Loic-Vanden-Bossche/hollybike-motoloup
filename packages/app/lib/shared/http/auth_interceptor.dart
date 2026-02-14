/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../auth/services/auth_persistence.dart';
import '../../auth/types/auth_session.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthPersistence authPersistence;
  final Dio _refreshDio = Dio();

  AuthInterceptor({required this.dio, required this.authPersistence});

  void _debugLog(String message) {
    if (!kDebugMode) return;
    developer.log(message, name: "AuthInterceptor");
  }

  dynamic _cloneRequestData(dynamic data) {
    if (data is FormData) {
      return data.clone();
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is List) {
      return List<dynamic>.from(data);
    }
    return data;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final currentSession = await authPersistence.currentSession;
    if (currentSession is AuthSession) {
      if (options.baseUrl.isEmpty) {
        options.baseUrl = "${currentSession.host}/api";
      }

      if (options.headers['Authorization'] == null) {
        options.headers['Authorization'] = 'Bearer ${currentSession.token}';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    void reject() {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.response,
        ),
      );
    }

    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['skipAuthRefresh'] == true) {
      return reject();
    }

    final authHeader = err.requestOptions.headers['Authorization'];
    final token =
        authHeader is String ? authHeader.replaceFirst('Bearer ', '') : null;

    if (token == null) {
      return reject();
    }

    final requestSession = await authPersistence.getSessionByToken(token);

    if (requestSession == null) {
      return reject();
    }

    AuthSession? newSession;

    final refreshLockKey = authPersistence.refreshLockKey(requestSession);

    try {
      if (authPersistence.isRefreshing(refreshLockKey)) {
        _debugLog(
          "Refresh already in progress for ${requestSession.host}/${requestSession.deviceId}. Waiting before retry.",
        );
        await authPersistence.waitIfRefreshing(refreshLockKey);
        newSession = await authPersistence.getSessionByHostAndDevice(
          requestSession.host,
          requestSession.deviceId,
        );
      } else {
        authPersistence.markRefreshing(refreshLockKey);
        _debugLog(
          "Requesting new JWT for ${requestSession.host}/${requestSession.deviceId}.",
        );
        newSession = await _renewSession(requestSession)
            .then((value) {
              _debugLog(
                "New JWT received for ${requestSession.host}/${requestSession.deviceId}. Updating session store.",
              );
              return authPersistence
                  .replaceSession(requestSession, value)
                  .then((_) => value);
            })
            .whenComplete(() {
              authPersistence.markRefreshDone(refreshLockKey);
            });
      }

      if (newSession == null) {
        return reject();
      }

      try {
        final clonedData = _cloneRequestData(err.requestOptions.data);
        final retryHeaders = Map<String, dynamic>.from(
          err.requestOptions.headers,
        );
        retryHeaders['Authorization'] = 'Bearer ${newSession.token}';
        if (clonedData is FormData) {
          // Let Dio regenerate multipart content-type and boundary for cloned form-data.
          retryHeaders.remove(Headers.contentTypeHeader);
        }

        _debugLog(
          "Retrying request ${err.requestOptions.method} ${err.requestOptions.path} with refreshed JWT.",
        );
        final response = await dio.fetch(
          err.requestOptions.copyWith(headers: retryHeaders, data: clonedData),
        );

        return handler.resolve(response);
      } on DioException catch (e) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          await onSessionExpired(requestSession);
        }

        return handler.reject(
          DioException(requestOptions: e.requestOptions, error: e.response),
        );
      }
    } on DioException catch (e) {
      // Expire only on explicit auth failures; transient network failures should not disconnect user.
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await onSessionExpired(requestSession);
      }

      return handler.reject(
        DioException(requestOptions: e.requestOptions, error: e.response),
      );
    }
  }

  Future<void> onSessionExpired(AuthSession session) async {
    final currentSession = await authPersistence.currentSession;

    if (currentSession == session) {
      authPersistence.expiredCurrentSession = session;
    }

    await authPersistence.removeSession(session);
  }

  Future<AuthSession> _renewSession(AuthSession oldSession) async {
    _refreshDio.options = BaseOptions(
      connectTimeout: dio.options.connectTimeout,
      receiveTimeout: dio.options.receiveTimeout,
      sendTimeout: dio.options.sendTimeout,
    );
    final newSessionResponse = await _refreshDio.patch(
      '${oldSession.host}/api/auth/refresh',
      options: Options(extra: {'skipAuthRefresh': true}),
      data: {"device": oldSession.deviceId, "token": oldSession.refreshToken},
    );

    return AuthSession.fromResponseJson(
      oldSession.host,
      newSessionResponse.data,
    );
  }
}
