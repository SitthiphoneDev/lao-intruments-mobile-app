import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lao_instruments/DI/service_locator.dart';
import 'package:lao_instruments/constants/language_code.dart';
import 'package:lao_instruments/routers/app_router.dart';
import 'package:lao_instruments/theme/app_themes.dart';

Future<void> main() async {
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale(LanguageCode.en)],
      path: "assets/translations",
      fallbackLocale: const Locale(LanguageCode.la),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lao Instruments AI',
      theme: AppThemes.main,
      debugShowCheckedModeBanner: false,
      routerConfig: getIt<AppRouter>().config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
