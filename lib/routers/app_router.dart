import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lao_instruments/features/audio/models/audio_models.dart';
import 'package:lao_instruments/features/audio/screens/audio_screen.dart';
import 'package:lao_instruments/features/audio/screens/detailed_instrument_screen.dart';
import 'package:lao_instruments/features/audio/screens/guide_screen.dart';
import 'package:lao_instruments/features/audio/screens/home_screen.dart';
import 'package:lao_instruments/features/audio/screens/main_navigation_screen.dart';
import 'package:lao_instruments/features/audio/screens/settings_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainNavigationRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: AudioRoute.page),
        AutoRoute(page: GuideRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: DetailedInstrumentRoute.page),
  ];
}
