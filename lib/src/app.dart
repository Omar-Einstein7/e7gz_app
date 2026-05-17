import 'package:e7gz/src/di/injection_container.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          Widget current = _buildMaterialApp(context, themeMode);
          current = ScreenUtilWrapper(child: current);
          return current;
        },
      ),
    );
  }

  Widget _buildMaterialApp(BuildContext context, ThemeMode themeMode) {
    return MaterialApp.router(
      title: 'e7gz',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#4be277'),
      darkTheme: buildDarkTheme(primaryColorHex: '#4be277'),
      themeMode: themeMode,
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
