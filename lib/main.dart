import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_strings.dart';
import 'core/localization/locale_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/services/get_it_service.dart';
import 'core/services/hive_service.dart';
import 'core/services/theme_cubit.dart';
import 'core/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await HiveService.init();
  await AppStrings.init();
  setupGetItService();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const ThaheenApp(),
    ),
  );
}

class ThaheenApp extends StatelessWidget {
  const ThaheenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeCubit>().state;
          final locale = context.watch<LocaleCubit>().state;

          return MaterialApp.router(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            locale: locale,
            builder: DevicePreview.appBuilder,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.seed,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.seed,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
