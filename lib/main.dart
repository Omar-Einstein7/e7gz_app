import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/app.dart';
import 'package:e7gz/src/di/injection_container.dart';
import 'package:e7gz/src/services/notification_service.dart';

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

  // Initialize Local Notifications
  await sl<NotificationService>().init();

  // Attach interceptors AFTER dependencies are registered
  AppConfig.attachInterceptors(
    secureStorage: sl<SecureStorageService>(),
    authService: sl<AuthService>(),
  );

  await sl<AuthService>().loadSavedToken();

  runApp(const LocalizationWrapper(child: StateWrapper(child: App())));
}
