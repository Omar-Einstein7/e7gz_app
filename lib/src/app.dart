
import 'package:e7gz/src/imports/core_imports.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Widget current = _buildMaterialApp(context);

    current = ScreenUtilWrapper(child: current);

    return current;
  }

  Widget _buildMaterialApp(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Starter',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#4be277'),
      darkTheme: buildDarkTheme(primaryColorHex: '#4be277'),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        Widget current = child!;
        current = SkeletonWrapper(child: current);
        current = SessionListenerWrapper(child: current);
        return current;
      },
    );
  }
}