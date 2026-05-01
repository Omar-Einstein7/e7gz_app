import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_bloc.dart';
import 'package:e7gz/src/routing/app_router.dart';
import 'package:e7gz/src/routing/app_routes.dart';

class SessionListenerWrapper extends StatelessWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status != SessionStatus.unknown) {
          FlutterNativeSplash.remove();
          if (state.status == SessionStatus.authenticated) {
            final user = state.user;
            if (user != null) {
              if (user.isAdmin) {
                // Use appRouter directly — context here is above MaterialApp.router
                // so context.go() would throw "No GoRouter found in context"
                appRouter.go(AppRoutes.admin);
              } else if (user.isOwner) {
                appRouter.go(AppRoutes.ownerDashboard);
              } else {
                appRouter.go(AppRoutes.home);
              }
            } else {
              appRouter.go(AppRoutes.home);
            }
          } else if (state.status == SessionStatus.unauthenticated) {
            appRouter.go(AppRoutes.onboarding);
          }
        }
      },
      child: child,
    );
  }
}
