import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:future_solutions/core/theme/app_theme.dart';
import 'package:future_solutions/flavors/app_flavor.dart';
import 'package:future_solutions/route/app_router.dart';

class App extends StatefulWidget {
  const App({required this.flavor, super.key});

  final AppFlavor flavor;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: widget.flavor.appTitle,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: _appRouter.config(),
      theme: AppTheme.light(),
    );

    if (!widget.flavor.isDevelopment) return app;

    return Banner(
      message: 'DEV',
      location: BannerLocation.topStart,
      color: Colors.orange.shade700,
      child: app,
    );
  }
}
