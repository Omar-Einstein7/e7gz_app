import 'dart:async';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/auth/domain/entities/user.dart';
import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';

/// Session states
enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState extends Equatable {
  final SessionStatus status;
  final AppUser? user;

  const SessionState({this.status = SessionStatus.unknown, this.user});

  const SessionState.unknown() : this();
  const SessionState.authenticated(AppUser user)
    : this(status: SessionStatus.authenticated, user: user);
  const SessionState.unauthenticated()
    : this(status: SessionStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository _repository;
  StreamSubscription<AppUser?>? _authSub;

  SessionCubit({required AuthRepository repository})
    : _repository = repository,
      super(const SessionState.unknown()) {
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    final result = await _repository.checkAuthState();
    result.fold((_) => emit(const SessionState.unauthenticated()), (user) {
      if (user != null) {
        emit(SessionState.authenticated(user));
      } else {
        emit(const SessionState.unauthenticated());
      }
    });

    // Listen for future changes
    await _authSub?.cancel();
    _authSub = _repository.onAuthStateChanged.listen((user) {
      updateUser(user);
    });
  }

  void updateUser(AppUser? user) {
    if (user != null) {
      emit(SessionState.authenticated(user));
    } else {
      emit(const SessionState.unauthenticated());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const SessionState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
