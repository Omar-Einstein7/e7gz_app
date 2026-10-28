# Refactoring Progress - e7gz App

## Status
- **Current Phase:** Phase 0 (Foundation & Cleanup)
- **Current Task:** Task 0.1 (Setup Core Structure & Baseline)

---

## 1. Done
- [x] Initial codebase audit (lib/src, pubspec.yaml, AGENTS.md, tests, analyzer).

---

## 2. In Progress
- [ ] **Task 0.1:** تأسيس الـ Core Layer ونقل الأساسيات المشتركة (Failures & Base Types) من `utils` إلى `core/errors` و `core/utils`.

---

## 3. Next Tasks (Proposed Roadmap)
### Phase 0: Foundation & Core Cleanup
- [ ] Task 0.1: Clean Core (Failures, Result/Either typedefs, Network/Error abstractions)
- [ ] Task 0.2: Standardization of Dio / HTTP Client & Base DataSource (توحيد Pattern A و Pattern B)
- [ ] Task 0.3: Modularity of DI (تقسيم `injection_container.dart` لـ Feature Modules)
- [ ] Task 0.4: التخلص من الـ God Imports (`imports/core_imports.dart`)

### Phase 1: Feature Refactoring
- [ ] Feature 1: Auth (Domain pure, Cubits, Data Sources, Repositories)
- [ ] Feature 2: Pitches
- [ ] Feature 3: Bookings
- [ ] Feature 4: Matchmaking
- [ ] Feature 5: Owner
- [ ] Feature 6: Admin
- [ ] Feature 7: Notifications
- [ ] Feature 8: Maps & Search
- [ ] Feature 9: Profile, Home & Onboarding

---

## 4. Bugs Found (Do Not Fix Without Approval)
1. **Analyzer Warning in Bookings DataSource:**
   - **Location:** `lib/src/features/bookings/data/datasources/booking_remote_datasource.dart:15:7`
   - **Issue:** `unawaited_return_in_try_block` (Returning a Future without `await` inside a try-catch block means exceptions from the Future bypass the catch block).
   - **Status:** Logged. Awaiting approval to fix during Bookings refactor.

---

## 5. Decisions & Trade-offs
- **State Management:** BLoC / Cubit (موجود بالفعل وشغال، هنلتزم بيه مع توحيد حالاته: Loading / Success / Empty / Error).
- **Domain Layer:** Pure Dart — ممنوع استيراد Flutter أو Firebase أو أي SDK خارجي داخل `domain/`.
- **FP Style:** استخدام `fpdart` (`Either<Failure, T>`) لتوحيد الـ Error Handling بدل الـ Exceptions في Presentation و Domain layers.
- **Dependency Injection:** Constructor Injection لكل الـ Classes، واستخدام `GetIt` فقط كـ Service Locator عند الـ Composition Root.
