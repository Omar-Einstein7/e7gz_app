import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/admin/domain/entities/admin_stats.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/auth/domain/entities/user.dart';

enum AdminStatus { initial, loading, success, failure }

class AdminState extends Equatable {
  final AdminStatus statsStatus;
  final AdminStats? stats;
  final String? statsError;

  final AdminStatus pitchesStatus;
  final List<Pitch> pitches;
  final String? pitchesError;

  final AdminStatus bookingsStatus;
  final List<Booking> bookings;
  final String? bookingsError;

  final AdminStatus matchesStatus;
  final List<MatchmakingMatch> matches;
  final String? matchesError;

  final AdminStatus notificationsStatus;
  final List<AppNotification> notifications;
  final String? notificationsError;

  final AdminStatus profileStatus;
  final AppUser? profile;
  final String? profileError;

  final bool isMutating;
  final String? mutationError;
  final bool mutationSuccess;

  const AdminState({
    this.statsStatus = AdminStatus.initial,
    this.stats,
    this.statsError,
    this.pitchesStatus = AdminStatus.initial,
    this.pitches = const [],
    this.pitchesError,
    this.bookingsStatus = AdminStatus.initial,
    this.bookings = const [],
    this.bookingsError,
    this.matchesStatus = AdminStatus.initial,
    this.matches = const [],
    this.matchesError,
    this.notificationsStatus = AdminStatus.initial,
    this.notifications = const [],
    this.notificationsError,
    this.profileStatus = AdminStatus.initial,
    this.profile,
    this.profileError,
    this.isMutating = false,
    this.mutationError,
    this.mutationSuccess = false,
  });

  AdminState copyWith({
    AdminStatus? statsStatus,
    AdminStats? stats,
    String? statsError,
    AdminStatus? pitchesStatus,
    List<Pitch>? pitches,
    String? pitchesError,
    AdminStatus? bookingsStatus,
    List<Booking>? bookings,
    String? bookingsError,
    AdminStatus? matchesStatus,
    List<MatchmakingMatch>? matches,
    String? matchesError,
    AdminStatus? notificationsStatus,
    List<AppNotification>? notifications,
    String? notificationsError,
    AdminStatus? profileStatus,
    AppUser? profile,
    String? profileError,
    bool? isMutating,
    String? mutationError,
    bool? mutationSuccess,
  }) {
    return AdminState(
      statsStatus: statsStatus ?? this.statsStatus,
      stats: stats ?? this.stats,
      statsError: statsError ?? this.statsError,
      pitchesStatus: pitchesStatus ?? this.pitchesStatus,
      pitches: pitches ?? this.pitches,
      pitchesError: pitchesError ?? this.pitchesError,
      bookingsStatus: bookingsStatus ?? this.bookingsStatus,
      bookings: bookings ?? this.bookings,
      bookingsError: bookingsError ?? this.bookingsError,
      matchesStatus: matchesStatus ?? this.matchesStatus,
      matches: matches ?? this.matches,
      matchesError: matchesError ?? this.matchesError,
      notificationsStatus: notificationsStatus ?? this.notificationsStatus,
      notifications: notifications ?? this.notifications,
      notificationsError: notificationsError ?? this.notificationsError,
      profileStatus: profileStatus ?? this.profileStatus,
      profile: profile ?? this.profile,
      profileError: profileError ?? this.profileError,
      isMutating: isMutating ?? this.isMutating,
      mutationError: mutationError ?? this.mutationError,
      mutationSuccess: mutationSuccess ?? this.mutationSuccess,
    );
  }

  @override
  List<Object?> get props => [
    statsStatus,
    stats,
    statsError,
    pitchesStatus,
    pitches,
    pitchesError,
    bookingsStatus,
    bookings,
    bookingsError,
    matchesStatus,
    matches,
    matchesError,
    notificationsStatus,
    notifications,
    notificationsError,
    profileStatus,
    profile,
    profileError,
    isMutating,
    mutationError,
    mutationSuccess,
  ];
}
