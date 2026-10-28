# Refactoring Progress - e7gz App

## Status
- **Current Phase:** Phase 0 (Cleanup & Baseline)
- **Current Task:** Task 0.1 (Baseline: branch + analyze + test numbers) - complete, awaiting owner confirmation
- **Branch:** `refactor/baseline` (from `main` @ 01d7b1f)

> Roadmap below follows the owner-approved plan (this chat); it supersedes the older numbering
> where Phase 0 contained core-layer moves. Dio/HTTP standardization (old Task 0.2) is folded
> into Phase 1 (unify services under `core/services`).

---

## 1. Done
- [x] Initial codebase audit (lib/src, pubspec.yaml, AGENTS.md, tests, analyzer).
- [x] Task 0.1: Baseline recorded (see "Baseline numbers"). Branch `refactor/baseline` created.

---

## 2. In Progress
- [ ] Task 0.1 verification by owner. Next: Task 0.2 (Root cleanup: remove temporary files from repo root).

---

## 3. Next Tasks
### Phase 0 (Cleanup)
- [ ] Task 0.2: Remove temporary files from repo root (verify each is expendable first).
- [ ] Task 0.3: Untrack `.env` (gitignore it, keep it as runtime asset for flutter_dotenv), create `.env.example`, owner rotates any exposed keys.
- [ ] Task 0.4: Tighten `analysis_options.yaml` (no new errors vs baseline). Notes: analyzer excludes `**/test/**` (consider removing); `strong-mode: implicit-casts: true` conflicts with `strict-casts: false`; `custom_lint` plugin declared but package not in dev_dependencies.
- [ ] Task 0.5: Run verification checks; write `docs/ARCHITECTURE.md`.
- [ ] Task 0.6: Rename `auth/presentation/providers` -> `auth/presentation/cubit` (contains Cubits: auth_cubit, session_cubit).

### Phase 1 (Core)
- [ ] Move Failure / error_handler / repository_helper / task_runner / typedefs from `utils` to `core` (utils are used by many features; move file-by-file with import updates).
- [ ] Unify all services under `core/services` (currently in `lib/src/services`; `lib/src/core` does not exist at all).
- [ ] Split `lib/src/di/injection_container.dart` into per-feature modules.
- [ ] Review `global_navigator` (routing/) and `session_listener_wrapper` usage.

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
