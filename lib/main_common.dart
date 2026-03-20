import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/app/app.dart';
import 'package:future_solutions/di/injection.dart';
import 'package:future_solutions/flavors/app_flavor.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> runMain(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final documentsDir = await getApplicationDocumentsDirectory();
  Hive.init(documentsDir.path);

  configureDependencies();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'lib/l10n/locales',
        fallbackLocale: const Locale('en'),
        child: App(flavor: flavor),
      ),
    ),
  );
}
