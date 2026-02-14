/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';
import 'dart:convert';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/utils/apply_on_future_or.dart';
import 'package:hollybike/shared/utils/calculate_future_or_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPersistence {
  final String key = "sessions-store";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  List<AuthSession>? _cachedSessions;

  List<AuthSession> _decodeSessions(String? payload) {
    if (payload == null || payload.isEmpty) return <AuthSession>[];

    final decoded = jsonDecode(payload) as List<dynamic>;
    return decoded
        .map((entry) => AuthSession.fromJson(jsonEncode(entry)))
        .toList();
  }

  FutureOr<List<AuthSession>> get sessions async {
    final cache = _cachedSessions;
    if (cache != null) {
      return cache;
    }

    final secureValue = await _secureStorage.read(key: key);
    if (secureValue != null) {
      final decoded = _decodeSessions(secureValue);
      _cachedSessions = decoded;
      return decoded;
    }

    // One-time migration from SharedPreferences to secure storage.
    final sharedPreferences = await SharedPreferences.getInstance();
    final legacySessions = sharedPreferences.getStringList(key);
    if (legacySessions == null || legacySessions.isEmpty) {
      _cachedSessions = <AuthSession>[];
      return <AuthSession>[];
    }

    final migratedSessions = legacySessions.map(AuthSession.fromJson).toList();
    _cachedSessions = migratedSessions;
    await _secureStorage.write(
      key: key,
      value: jsonEncode(
        migratedSessions.map((session) => session.asMap()).toList(),
      ),
    );
    await sharedPreferences.remove(key);

    return migratedSessions;
  }

  Future<void> _persistSessions(List<AuthSession> newSessions) async {
    await _secureStorage.write(
      key: key,
      value: jsonEncode(
        newSessions.map((newSession) => newSession.asMap()).toList(),
      ),
    );

    // Clean old storage key if present.
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  Future<bool> get isConnected async => (await sessions).isNotEmpty;

  Future<bool> get isDisconnected async => !(await isConnected);

  final BehaviorSubject<AuthSession> _expiredSession = BehaviorSubject();

  Stream<AuthSession> get currentSessionExpiredStream => _expiredSession.stream;

  bool currentSessionExpired = false;

  set expiredCurrentSession(AuthSession session) {
    _expiredSession.add(session);
    currentSessionExpired = true;
  }

  set sessions(FutureOr<List<AuthSession>> newFutureSessions) {
    if (newFutureSessions is List<AuthSession>) {
      final loadedSessions = List<AuthSession>.from(newFutureSessions);
      _cachedSessions = loadedSessions;
      unawaited(_persistSessions(loadedSessions));
      return;
    }

    newFutureSessions.apply((newSessions) async {
      final loadedSessions = List<AuthSession>.from(newSessions);
      _cachedSessions = loadedSessions;
      await _persistSessions(loadedSessions);
    });
  }

  FutureOr<AuthSession?> get currentSession async =>
      (await sessions).firstOrNull;

  set currentSession(FutureOr<AuthSession?> session) {
    if (session == null) return;
    if (session is Future<AuthSession?>) {
      session.then((resolvedSession) {
        if (resolvedSession != null) {
          currentSession = resolvedSession;
        }
      });
      return;
    }

    currentSessionExpired = false;
    final resolvedSession = session as AuthSession;
    final current = _cachedSessions ?? <AuthSession>[];
    final updatedSessions = [
      resolvedSession,
      ...current.where((savedSession) => savedSession != resolvedSession),
    ];
    _cachedSessions = updatedSessions;
    unawaited(_persistSessions(updatedSessions));
  }

  Future<void> removeSession(AuthSession session) async {
    sessions = sessions - session;
  }

  Future<void> replaceSession(
    AuthSession oldSession,
    AuthSession newSession,
  ) async {
    sessions = (sessions - oldSession).add(newSession);
  }

  Future<AuthSession?> getSessionByToken(String token) async {
    try {
      return (await sessions).firstWhere((session) => session.token == token);
    } catch (e) {
      return null;
    }
  }

  Future<AuthSession?> getSessionByHostAndDevice(
    String host,
    String deviceId,
  ) async {
    try {
      return (await sessions).firstWhere(
        (session) => session.host == host && session.deviceId == deviceId,
      );
    } catch (e) {
      return null;
    }
  }

  final Map<String, Completer<void>> _refreshLocks = {};

  String refreshLockKey(AuthSession session) =>
      "${session.host}|${session.deviceId}";

  bool isRefreshing(String lockKey) => _refreshLocks[lockKey] != null;

  void markRefreshing(String lockKey) {
    _refreshLocks.putIfAbsent(lockKey, () => Completer<void>());
  }

  void markRefreshDone(String lockKey) {
    final completer = _refreshLocks.remove(lockKey);
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  Future<void> waitIfRefreshing(
    String lockKey, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final completer = _refreshLocks[lockKey];
    if (completer == null) return;

    try {
      await completer.future.timeout(timeout);
    } catch (e) {
      return;
    }
  }
}
