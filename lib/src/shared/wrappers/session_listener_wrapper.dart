import 'package:e7gz/src/imports/core_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
import 'package:e7gz/src/routing/app_router.dart';
import 'package:e7gz/src/routing/app_routes.dart';

// Import Cubits for data triggering
import 'package:e7gz/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e7gz/src/features/notifications/presentation/cubit/notifications_cubit.dart';

import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

class SessionListenerWrapper extends StatelessWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        AppLogger.info('🔄 SessionListenerWrapper: Status changed to ${state.status}');
        
        if (state.status != SessionStatus.unknown) {
          FlutterNativeSplash.remove();
          
          if (state.status == SessionStatus.authenticated) {
            final user = state.user;
            AppLogger.info('👤 User authenticated: ${user?.email} (Role: ${user?.role})');
            
            // Trigger common data loads for all roles
            context.read<ProfileCubit>().loadProfileData();
            context.read<NotificationsCubit>().loadNotifications();

            if (user != null) {
              if (user.isAdmin) {
                AppLogger.info('🛡️ Redirecting to Admin Dashboard');
                appRouter.go(AppRoutes.admin);
              } else if (user.isOwner) {
                AppLogger.info('🏠 Redirecting to Owner Dashboard');
                appRouter.go(AppRoutes.ownerDashboard);
              } else {
                AppLogger.info('⚽ Redirecting to Home (Regular User)');
                // Regular User specific data loads
                context.read<HomeCubit>().loadHomeData();
                context.read<MatchmakingCubit>().loadMatches();
                appRouter.go(AppRoutes.home);
              }
            } else {
              AppLogger.warning('⚠️ User is null but status is authenticated. Fallback to home.');
              // Fallback for null user (should not happen if authenticated)
              context.read<HomeCubit>().loadHomeData();
              appRouter.go(AppRoutes.home);
            }
          } else if (state.status == SessionStatus.unauthenticated) {
            AppLogger.info('🚪 User unauthenticated. Staying/Redirecting to onboarding if necessary.');
            appRouter.go(AppRoutes.onboarding);
          }
        }
      },
      child: child,
    );
  }
}
