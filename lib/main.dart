import 'package:flutter/rendering.dart';

import 'src/imports/core_imports.dart';
import 'src/imports/packages_imports.dart';
import 'src/app.dart';
import 'src/di/injection_container.dart';

Future<void> main() async {
  // debugRepaintRainbowEnabled = true;
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AppConfig.init();

  // Register all dependencies with get_it (sync — no async registrations)
  await initDependencies();

  // Attach interceptors AFTER dependencies are registered
  AppConfig.attachInterceptors(
    secureStorage: sl<SecureStorageService>(),
    authService: sl<AuthService>(),
  );

  await sl<AuthService>().loadSavedToken();

  runApp(const LocalizationWrapper(child: StateWrapper(child: App())));
}
