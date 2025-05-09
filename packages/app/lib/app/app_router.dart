/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthPersistence authPersistence;

  AppRouter({required this.authPersistence});

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          initial: true,
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: EventsRoute.page,
          path: '/events',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: EventDetailsRoute.page,
          path: '/event-details',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: EventParticipationsRoute.page,
          path: '/event-participations',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: EventCandidatesRoute.page,
          path: '/event-candidates',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: ImageGalleryViewRoute.page,
          path: '/image-view',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: ImportGpxToolRoute.page,
          path: '/import-gpx-tool',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: MeRoute.page,
          path: '/me',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: ProfileRoute.page,
          path: '/profile/:id',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: SearchRoute.page,
          path: '/search',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: UserJourneyMapRoute.page,
          path: '/user-journey-map',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          guards: [AuthGuard(authPersistence: authPersistence)],
          page: EditProfileRoute.page,
          path: '/edit-profile',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: SignupRoute.page,
          path: '/invite',
        ),
        AutoRoute(
          page: LoadingRoute.page,
          path: '/load',
        ),
        RedirectRoute(
          path: '*',
          redirectTo: '/events',
        ),
      ];
}
