# Refactoring Progress - e7gz App

## Status
- **Current Phase:** Phase 2 (Features Refactoring)
- **Current Feature:** Feature 10 — Profile
- **Current Task:** Profile Task 1: Audit
- **Branch:** `refactor/baseline`

> Roadmap below follows the owner-approved plan (this chat); it supersedes the older numbering
> where Phase 0 contained core-layer moves. Dio/HTTP standardization (old Task 0.2) is folded
> into Phase 1 (unify services under `core/services`).

---

## 1. Done
- [x] Initial codebase audit (lib/src, pubspec.yaml, AGENTS.md, tests, analyzer).
- [x] Task 0.1: Baseline recorded (see "Baseline numbers"). Branch `refactor/baseline` created.
- [x] Task 0.2: Remove temporary files and patch scripts from repo root (committed: `dbed0a9`).
- [x] Task 0.3: Untrack `.env` and create `.env.example` with gitignore exception (committed: `5d8caf1`, `73f1740`).
- [x] Task 0.4: Tighten `analysis_options.yaml` (clean deprecated configs, remove phantom custom_lint, un-exclude tests, ensure 0 errors) (committed: `0101ad8`).
- [x] Task 0.5: Run verification checks; write `docs/ARCHITECTURE.md` (committed: `8668477`).
- [x] Task 0.6: Rename `auth/presentation/providers` -> `auth/presentation/cubit` (committed: `2885535`, `4fbeae0`).
- [x] Task 1.1: Move Failure / error_handler / repository_helper / task_runner / typedefs to core (committed: `6bd33bd`, `0b72c59`, `f89cf5e`).
- [x] Task 1.2: Unify all services under `core/services` (committed: `830df07`, `e5f17a1`).
- [x] Task 1.3: Split injection container into modular feature modules under `core/di` and remove legacy `di/` (committed: `b9d27e5`, `0a85b96`).
- [x] Task 1.4: Review `global_navigator` (routing/) and `session_listener_wrapper` usage.
- [x] Feature 1 (Auth) — Task 1: Clean Domain & Data Imports (committed: `6230f77`).
- [x] Feature 1 (Auth) — Task 2: Presentation Layer Cleanup (Cubit & States Explicit Imports) (committed: `c5f07ef`).
- [~] Feature 1 (Auth) — Task 3: Unit Testing — **DEFERRED** (Omar: "سيبك من التيست دلوقتي"). Will revisit after all features refactored.

---

## 2. In Progress
- [x] Feature 2 (Pitches) — Task 1: Clean Domain imports (`pitch_usecases.dart`) (committed: `de47f7a`).
- [x] Feature 2 (Pitches) — Task 2: Clean Data imports (`pitch_remote_datasource.dart`, `pitch_repository_impl.dart`) (committed: `de47f7a`).
- [x] Feature 2 (Pitches) — Task 3: Add `Review` Entity, fix `PitchDetailCubit` violations — removed `sl<>` + `DataSource` calls, wired `GetPitchReviewsUseCase` + `CreateReviewUseCase` via constructor (committed: `965ae16`).
- [x] Feature 3 (Bookings) — Task 1: Clean Data imports (`booking_repository_impl.dart` removed God Barrel).
- [x] Feature 3 (Bookings) — Task 2: Fix `CreateBookingCubit` DI violation — injected `NotificationService` via constructor and wired in `bookings_di.dart`.
- [x] Feature 4 (Home) — Task 1: Standardized `home_repository_impl.dart` using `runTask` and cleaned imports.
- [x] Feature 4 (Home) — Task 2: Cleaned `home_cubit.dart` imports (replaced God Barrel with explicit `flutter_bloc`).
- [x] Feature 5 (Matchmaking) — Task 1: Created `CreateMatchRequest` in Domain and removed `MatchModel` dependency from `MatchRepository`.
- [x] Feature 5 (Matchmaking) — Task 2: Standardized `MatchRepositoryImpl` with `runTask` and cleaned `MatchRemoteDataSource` imports.
- [x] Feature 5 (Matchmaking) — Task 3: Cleaned `MatchmakingCubit` imports and updated `CreateMatchScreen` to use `CreateMatchRequest`.
- [x] Feature 6 (Owner) — Task 1: Standardized `OwnerRepositoryImpl` using `runTask` and removed boilerplate `try/catch`.
- [x] Feature 6 (Owner) — Task 2: Cleaned `OwnerCubit` imports (replaced God Barrel with explicit imports).
- [x] Feature 7 (Admin) — Task 1: Cleaned `AdminRepository` imports (`typedefs.dart`).
- [x] Feature 7 (Admin) — Task 2: Refactored `AdminRepositoryImpl` with `runTask` across all 11 methods, removed God Barrels.
- [x] Feature 7 (Admin) — Task 3: Cleaned `AdminCubit` imports (replaced `core_imports.dart` with `logger.dart`).
- [x] Feature 8 (Notifications) — Task 1: Cleaned `AppNotification` Entity (Pure Dart + Equatable, removed duplicate `fromJson`), cleaned repo & usecase imports.
- [x] Feature 8 (Notifications) — Task 2: Standardized `NotificationRepositoryImpl` with `runTask` across all 4 methods.
- [x] Feature 8 (Notifications) — Task 3: Cleaned `NotificationsCubit` imports (replaced `imports.dart` with `flutter_bloc`).
- [x] Feature 9 (Maps & Search) — Task 1: Standardized `MapsRepositoryImpl` with `runTask`.
- [x] Feature 9 (Maps & Search) — Task 2: Cleaned `SearchRepositoryImpl` imports (removed `core_imports.dart`).
- [x] Feature 9 (Maps & Search) — Task 3: Cleaned `SearchCubit` imports (replaced `imports.dart` with `flutter_bloc`).

---

## 3. Next Tasks
### Phase 2 (Features, in order)
- **Feature 1: Auth**
  - [ ] Auth Task 3: Unit Testing for Auth (AuthCubit & SessionCubit suites).
- **Feature 2: Pitches** (Audit -> Domain -> Data -> Presentation -> DI -> Tests)
- **Remaining Features:**
  bookings -> home -> matchmaking -> owner -> admin -> notifications -> maps/search -> profile -> splash/onboarding -> theme.
  pitches -> bookings -> home -> matchmaking -> owner -> admin -> notifications -> maps/search -> profile -> splash/onboarding -> theme.
  Per-feature template: Audit -> Target structure -> Domain -> Data -> Presentation (Cubit + states) -> DI -> Routing -> Tests -> Gate -> Commit.

### Phase 2 (Features, in order)
auth -> pitches -> bookings -> home -> matchmaking -> owner -> admin -> notifications -> maps/search -> profile -> splash/onboarding -> theme.
Per-feature template: Audit -> Target structure -> Domain -> Data -> Presentation (Cubit + states) -> DI -> Routing -> Tests -> Gate -> Commit.

---

## 4. Bugs Found (Do Not Fix Without Approval)
1. **Analyzer warning in Bookings DataSource:**
   - **Location:** `lib/src/features/bookings/data/datasources/booking_remote_datasource.dart:15:7`
   - **Issue:** `unawaited_return_in_try_block` (returned Future bypasses the catch block on error).
   - **Status:** Logged. Approved fix driven by owner only.

---

## 5. Decisions & Trade-offs
- **State management:** Bloc/Cubit already in use and working; keep it, standardize states to Loading / Success / Empty / Error.
- **Domain layer:** Pure Dart only. No Flutter, no Firebase, no Dio imports inside `domain/`.
- **Error handling:** Data layer converts exceptions/protocol errors to `Failure` (fpdart `Either<Failure, T>`); no exceptions thrown to domain/presentation.
- **Use cases:** Only when there is real business logic. No pass-through use cases.
- **DI:** Constructor injection everywhere; GetIt only for registration in the composition root. No GetIt calls inside Cubits or UI.
- **Barrel files:** Keep behavior as-is during refactor; strategy revisited when touching `imports/`.
- **.env:** Never edit/delete the file; untrack from git only, since flutter_dotenv reads it at runtime as a Flutter asset.

---

## 6. Baseline Numbers
- **flutter analyze:** 1 warning, 0 errors, 0 infos (~67s). The single warning is the bookings issue in section 4.
- **flutter test:** 1 file, 5 tests, all passed (auth RepositoryImpl suite only; coverage is minimal repo-wide).
- **Verified structural facts:** no `lib/src/core/`; services in `lib/src/services`; failure/error_handler/typedefs in `lib/src/utils`; DI in `lib/src/di/injection_container.dart`; only 1 test file; `.env` is tracked by git AND listed under pubspec assets.
