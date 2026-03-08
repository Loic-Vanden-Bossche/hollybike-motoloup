/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:hollybike/app/app_router.gr.dart';

import '../services/auth_persistence.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthPersistence authPersistence;

  AuthGuard({required this.authPersistence});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await authPersistence.isDisconnected ||
        authPersistence.currentSessionExpired) {
      router.push(
        LoginRoute(
          onAuthSuccess: () {
            // Resolve the original navigation first so the target screen is
            // rendered, then remove the login route from the back-stack on the
            // next frame.  Using canPop()/pop() is not reliable here because
            // on a fresh launch the login screen IS the root entry and
            // canPop() returns false, leaving login underneath the target.
            resolver.next(true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              router.removeWhere((route) => route.name == LoginRoute.name);
            });
          },
        ),
      );
    } else {
      resolver.next(true);
    }
  }
}
