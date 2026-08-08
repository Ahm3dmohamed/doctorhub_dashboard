import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/cubit/locale_cubit.dart';
import '../app/cubit/theme_cubit.dart';
import '../app/di/injection.dart';
import '../app/router/app_router.dart';
import '../app/theme/app_theme.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';

class DoctorHubApp extends StatefulWidget {
  const DoctorHubApp({super.key});

  @override
  State<DoctorHubApp> createState() => _DoctorHubAppState();
}

class _DoctorHubAppState extends State<DoctorHubApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;
  final ThemeCubit _themeCubit = ThemeCubit();
  late final LocaleCubit _localeCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
    _localeCubit = LocaleCubit(sl<SharedPreferences>());
    _router = AppRouter.createRouter(_authCubit);

    _authCubit.checkAuthStatus();
  }

  @override
  void dispose() {
    _authCubit.close();
    _themeCubit.close();
    _localeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: _authCubit),
        BlocProvider<ThemeCubit>.value(value: _themeCubit),
        BlocProvider<LocaleCubit>.value(value: _localeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        bloc: _themeCubit,
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            bloc: _localeCubit,
            builder: (context, locale) {
              return MaterialApp.router(
                title: 'DoctorHub',
                debugShowCheckedModeBanner: false,

                // Theme
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,

                // Localization
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,

                // Navigation
                routerConfig: _router,
              );
            },
          );
        },
      ),
    );
  }
}
