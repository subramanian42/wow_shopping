import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/bloc/bloc/app_bloc.dart';
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends StatefulWidget {
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  State<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends State<ShopWowApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(InitializeAppEvent()),
      child: const ShopWowView(),
    );
  }
}

class ShopWowView extends StatefulWidget {
  const ShopWowView({super.key});

  @override
  State<ShopWowView> createState() => _ShopWowViewState();
}

class _ShopWowViewState extends State<ShopWowView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) {
        return switch (state) {
          AppInitial() => const AppInitialView(),
          SuccessState() =>
            AppView(navigatorKey: _navigatorKey, data: state.data),
          FailureState() => const ErrorScreen()
        };
      }),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
        child: Material(
      child: Center(
        child: Text('Error!'),
      ),
    ));
  }
}

class AppInitialView extends StatelessWidget {
  const AppInitialView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: generateLightTheme(),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: SplashScreen(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView(
      {super.key,
      required GlobalKey<NavigatorState> navigatorKey,
      required this.data})
      : _navigatorKey = navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;
  final Backend data;
  @override
  Widget build(BuildContext context) {
    return BackendInheritedWidget(
      backend: data,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        title: _appTitle,
        theme: generateLightTheme(),
        home: const MainScreen(),
      ),
    );
  }
}
