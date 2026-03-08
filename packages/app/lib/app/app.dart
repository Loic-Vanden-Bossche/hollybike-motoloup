/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hollybike/app/app_router.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/guards/auth_stream.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'app_router.gr.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_event.dart';
import 'package:hollybike/positions/background/tracking_nav_intent.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class App extends StatefulWidget {
  final AuthPersistence authPersistence;

  const App({super.key, required this.authPersistence});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter appRouter;
  late final AuthStream authChangeNotifier;
  late final EventRepository _eventRepository;
  StreamSubscription<int>? _navSubscription;
  AuthSession? _lastAuthSession;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting(
      "fr_FR",
    ).then((value) => Intl.defaultLocale = "fr_FR");

    MapboxOptions.setAccessToken(
      const String.fromEnvironment('PUBLIC_ACCESS_TOKEN'),
    );

    appRouter = AppRouter(authPersistence: widget.authPersistence);
    authChangeNotifier = AuthStream(
      context,
      authPersistence: widget.authPersistence,
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    _eventRepository = RepositoryProvider.of<EventRepository>(context);
    _lastAuthSession = context.read<AuthBloc>().state.authSession;

    // Warm-start: navigate whenever the tracking notification is tapped while
    // the app is already running.
    _navSubscription = TrackingNavIntent.stream.listen(_navigateToTrackingEvent);

    // Cold-start: pull any event ID stored by MainActivity before Dart started.
    // Deferred to post-frame so the router has settled on its initial route.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TrackingNavIntent.checkPendingNavIntent();
    });
  }

  @override
  void dispose() {
    _navSubscription?.cancel();
    super.dispose();
  }

  Future<void> _navigateToTrackingEvent(int eventId) async {
    try {
      final details = await _eventRepository.fetchEventDetails(eventId);
      appRouter.navigate(EventDetailsRoute(event: details.event.toMinimalEvent()));
    } catch (_) {
      // Best effort — if the fetch fails, the user stays on the current screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final previousSession = _lastAuthSession;
        final currentSession = state.authSession;

        final disconnected = currentSession == null;
        final switchedAccount =
            previousSession != null &&
            currentSession != null &&
            _sessionIdentity(previousSession) != _sessionIdentity(currentSession);

        if (disconnected) {
          _stopAllBackgroundServices(context);
          _lastAuthSession = currentSession;
          return;
        }

        if (switchedAccount) {
          _stopAllBackgroundServices(context);
          context.read<NotificationBloc>().add(
            StartNotificationService(currentSession),
          );
          _lastAuthSession = currentSession;
          return;
        }

        if (previousSession == null) {
          context.read<NotificationBloc>().add(
            StartNotificationService(currentSession),
          );
        }

        _lastAuthSession = currentSession;
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              systemNavigationBarContrastEnforced: false,
              systemStatusBarContrastEnforced: false,
              systemNavigationBarIconBrightness:
                  state.isDark ? Brightness.light : Brightness.dark,
              statusBarIconBrightness:
                  state.isDark ? Brightness.light : Brightness.dark,
            ),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: MaterialApp.router(
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
                supportedLocales: const [Locale('fr', 'FR')],
                title: 'Hollybike',
                theme: BlocProvider.of<ThemeBloc>(context).getThemeData,
                routerConfig: appRouter.config(
                  reevaluateListenable: authChangeNotifier,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _stopAllBackgroundServices(BuildContext context) {
    context.read<NotificationBloc>().add(StopNotificationService());
    context.read<MyPositionBloc>().add(DisableSendPositions());
  }

  String _sessionIdentity(AuthSession session) => '${session.host}|${session.email}';
}
