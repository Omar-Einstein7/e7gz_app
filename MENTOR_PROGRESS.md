# Refactoring Progress - e7gz App

## Status
- **Current Phase:** Phase 2 (Features Refactoring)
- **Current Feature:** Feature 1 — Auth
- **Current Task:** Auth Task 2: Presentation Layer Cleanup (Cubit & States Explicit Imports)
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

---

## 2. In Progress
- [ ] Feature 1 (Auth) — Task 2: Presentation Layer Cleanup (Cubit & States Explicit Imports).

---

## 3. Next Tasks
### Phase 2 (Features, in order)
- **Feature 1: Auth**
  - [ ] Auth Task 2: Presentation Layer Cleanup (Cubit & States Explicit Imports).
  - [ ] Auth Task 3: Unit Testing for Auth (AuthCubit & SessionCubit suites).
- **Remaining Features:**
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
