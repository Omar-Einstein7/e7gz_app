import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:e7gz/src/features/auth/presentation/providers/session_bloc.dart';
import 'package:e7gz/src/routing/app_router.dart';
import 'package:e7gz/src/routing/app_routes.dart';

// Import Cubits for data triggering
import 'package:e7gz/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e7gz/src/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

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
            // Trigger initial data loads only after authentication
            context.read<HomeCubit>().loadHomeData();
            context.read<ProfileCubit>().loadProfileData();
            context.read<NotificationsCubit>().loadNotifications();
            context.read<PitchesCubit>().loadPitches(refresh: true);
            context.read<MatchmakingCubit>().loadMatches();

            final user = state.user;
            if (user != null) {
              if (user.isAdmin) {
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
