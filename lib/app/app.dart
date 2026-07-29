import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../app/di/injection.dart';
import '../app/router/app_router.dart';
import '../app/theme/app_theme.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';

/// DoctorHub Root Application Widget
class DoctorHubApp extends StatefulWidget {
  const DoctorHubApp({super.key});

  @override
  State<DoctorHubApp> createState() => _DoctorHubAppState();
}

class _DoctorHubAppState extends State<DoctorHubApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
    _router = AppRouter.createRouter(_authCubit);

    // Restore session on startup
    _authCubit.checkAuthStatus();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: 'DoctorHub',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark for the premium look

        // Routing
        routerConfig: _router,
      ),
    );
  }
}
