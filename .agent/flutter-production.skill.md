---
name: flutter-production
description: >
  Use this skill whenever the user wants to prepare, audit, build, or verify a Flutter app for
  production release. Triggers include: "production build", "release mode", "app store ready",
  "check for errors", "watch terminal", "flutter build issues", "release APK/IPA", "deploy flutter",
  "flutter production checklist", "flutter app not working in release", or any request to validate
  that a Flutter app is production-ready. Also trigger when the user mentions debugging release-mode
  crashes, signing issues, obfuscation, performance profiling, or wants to run a full health check
  on their Flutter project before shipping. Use this skill even if they just say "make sure my
  Flutter app is ready" or "check everything is working".
---

# Flutter Production Readiness Skill

A comprehensive skill for auditing, building, and verifying Flutter apps for production deployment.
This skill covers the full pipeline: static analysis → dependency audit → build → terminal monitoring
→ release validation.

---

## Phase 0 — Understand the Project First

Before running anything, gather context:

```bash
# Get project structure
ls -la
cat pubspec.yaml
flutter --version
```

Ask the user (if not obvious):
- Target platform? (Android / iOS / Web / Desktop — or all)
- Which flavor/environment? (dev / staging / prod)
- Do they have signing keys configured?
- Is this a first release or an update?

---

## Phase 1 — Static Analysis & Code Quality

Run these in order. Fix ALL issues before proceeding.

```bash
# 1. Analyze for errors, warnings, hints
flutter analyze --fatal-infos

# 2. Check for outdated / insecure dependencies
flutter pub outdated

# 3. Verify dependencies resolve cleanly
flutter pub get

# 4. Run dart format check (don't auto-fix in CI — just report)
dart format --output=none --set-exit-if-changed .

# 5. Run tests
flutter test --coverage
```

**What to watch for:**
- Any `error` lines → must fix before building
- `warning` lines → fix unless intentionally suppressed with `// ignore:`
- Failed tests → must fix or explicitly document why skipped
- Outdated packages with security advisories → update or pin with justification

---

## Phase 2 — pubspec.yaml Audit

Review `pubspec.yaml` manually and check:

```yaml
# ✅ Version must have build number for stores
version: 1.0.0+1   # format: semver+buildNumber

# ✅ Environment SDK constraints should be tight
environment:
  sdk: '>=3.0.0 <4.0.0'

# ✅ No path: dependencies in production
dependencies:
  my_local_pkg:
    path: ../my_local_pkg   # ❌ Not allowed in production builds
```

**Red flags to catch:**
- `path:` dependencies → must be published packages or removed
- `git:` dependencies without a pinned `ref:` → unpredictable builds
- Duplicate or conflicting package versions
- Missing `description` or `homepage` fields (required for pub.dev publishing)

---

## Phase 3 — Environment & Secrets Audit

```bash
# Check for hardcoded secrets or API keys
grep -r "api_key\|apiKey\|secret\|password\|token\|API_KEY" lib/ --include="*.dart" -i

# Check .gitignore covers sensitive files
cat .gitignore | grep -E "\.env|keystore|key\.properties|google-services|GoogleService"
```

**Required in `.gitignore`:**
```
*.keystore
*.jks
key.properties
google-services.json      # Or use CI injection
GoogleService-Info.plist  # Or use CI injection
.env
```

**Dart-side:** Use `--dart-define` or a secrets package, never raw string literals.

---

## Phase 4 — Android Production Checklist

### 4a. Signing Configuration

```bash
# Verify key.properties exists and points to a valid keystore
cat android/key.properties
```

`android/app/build.gradle` must have:
```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true       // Enable R8/ProGuard
            shrinkResources true
        }
    }
}
```

### 4b. AndroidManifest.xml Checks

```bash
cat android/app/src/main/AndroidManifest.xml
```

Verify:
- `android:debuggable` is NOT set to `true` (release builds handle this automatically)
- `android:allowBackup` is intentionally set
- All required permissions are declared
- Internet permission if using network: `<uses-permission android:name="android.permission.INTERNET"/>`
- No test/debug activities included

### 4c. Build Android Release

```bash
# AAB (preferred for Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info/android

# OR APK for direct distribution
flutter build apk --release --obfuscate --split-debug-info=./debug-info/android

# Verify the output
ls -lh build/app/outputs/bundle/release/
```

**Watch terminal for:**
- `FAILURE: Build failed` → check Gradle logs above the error
- `Keystore was tampered with, or password was incorrect` → signing config issue
- `minSdkVersion` conflicts → check all packages' min SDK requirements

---

## Phase 5 — iOS Production Checklist

### 5a. Xcode & Signing

```bash
# Open workspace (not .xcodeproj)
open ios/Runner.xcworkspace
```

Check in Xcode → Runner target → Signing & Capabilities:
- Team is set to your Apple Developer account
- Bundle Identifier matches App Store Connect
- Provisioning Profile is "Automatic" or a valid Distribution profile
- No "Signing Certificate" errors

### 5b. Info.plist Checks

```bash
cat ios/Runner/Info.plist
```

Verify:
- `NSAppTransportSecurity` → `NSAllowsArbitraryLoads` is `false` in production
- All required usage descriptions present (camera, location, etc.)
- `CFBundleVersion` and `CFBundleShortVersionString` are correct

### 5c. Build iOS Release

```bash
# Build without codesign (for CI) — for local use, open Xcode and Archive
flutter build ipa --release --obfuscate --split-debug-info=./debug-info/ios

# Check output
ls -lh build/ios/ipa/
```

---

## Phase 6 — Terminal Monitoring (Live Error Watch)

Use this to run the release build on a connected device and watch for runtime errors:

```bash
# Run in release mode on connected device
flutter run --release 2>&1 | tee release_run.log

# In a second terminal — watch for exceptions, errors, crashes
tail -f release_run.log | grep -E "Exception|Error|FATAL|CRASH|Unhandled|FlutterError" --color=always
```

**For Android crash logs specifically:**
```bash
# Watch Android logcat filtered to Flutter
adb logcat | grep -E "flutter|AndroidRuntime|FATAL" --color=always
```

**For iOS crash logs:**
```bash
# Stream iOS device logs
idevicesyslog | grep -E "Runner|flutter|Exception" --color=always
```

**Common release-mode-only errors to watch for:**

| Error Pattern | Likely Cause |
|---|---|
| `MissingPluginException` | Plugin not registered in release mode |
| `null check operator used on a null value` | Null safety issue hidden by debug assertions |
| `SocketException` | Network permission missing or cleartext HTTP blocked |
| `Invalid signature` / `DRM` errors | Signing issue |
| `Obfuscation` related crashes | Missing `--split-debug-info` or ProGuard stripping too aggressively |
| `PlatformException` | Native plugin initialization failed |

---

## Phase 7 — Performance Validation

```bash
# Profile mode (nearest to release, with profiling overhead)
flutter run --profile

# Run Flutter DevTools for performance analysis
flutter pub global activate devtools
flutter pub global run devtools
```

**Targets:**
- Startup time < 2s on mid-range device
- 60fps (or 120fps if device supports) during scroll/animation
- No frame build times > 16ms (visible in DevTools → Performance tab)
- Memory usage stable (no growing leak pattern)

---

## Phase 8 — Final Verification Checklist

Run this before every release:

```bash
flutter clean
flutter pub get
flutter analyze --fatal-infos
flutter test
flutter build appbundle --release   # or ipa for iOS
```

**Manual checks:**
- [ ] App version and build number bumped in `pubspec.yaml`
- [ ] Changelog / release notes written
- [ ] All debug flags (`kDebugMode` guards) verified
- [ ] No `print()` statements in production code (use a logging package)
- [ ] Crashlytics / Sentry / error reporting configured and tested
- [ ] Deep links / Universal Links tested in release mode
- [ ] Push notifications tested in release mode (different APNs environment)
- [ ] ProGuard/R8 rules added for any reflection-based packages
- [ ] App tested on a real device, not just simulator

---

## Phase 9 — Common Release Build Fixes

### Fix: Plugin not working in release
```bash
# Check if plugin requires ProGuard rules
# Add to android/app/proguard-rules.pro:
-keep class com.example.myplugin.** { *; }
```

### Fix: Network calls failing in release (Android)
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application android:usesCleartextTraffic="false">  <!-- force HTTPS -->
```

### Fix: dart:mirrors or reflection crashes after obfuscation
```bash
# Add to build command:
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=./debug-info \
  --no-tree-shake-icons   # if icon issues appear
```

### Fix: iOS App Transport Security blocking HTTP
```xml
<!-- ios/Runner/Info.plist — only for exceptions, not global -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>your-api-domain.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>   <!-- Keep false! Use HTTPS -->
        </dict>
    </dict>
</dict>
```

---

## Output Format

After completing each phase, report results in this structure:

```
## Phase N — [Name]
Status: ✅ PASSED | ⚠️ WARNINGS | ❌ FAILED

[List findings, errors, fixes applied]
```

At the end, provide a **Production Readiness Summary**:
```
## Production Readiness Summary
Platform: Android / iOS / Web
Build: ✅ Succeeded / ❌ Failed
Analysis: ✅ Clean / ⚠️ N warnings / ❌ N errors  
Tests: ✅ N passed / ❌ N failed
Signing: ✅ Configured / ❌ Missing
Terminal monitoring: ✅ No runtime errors / ❌ Errors found

VERDICT: ✅ READY FOR RELEASE | ⚠️ READY WITH CAVEATS | ❌ NOT READY
```