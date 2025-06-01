import 'package:auto_route/auto_route.dart';
import 'package:lao_instruments/features/audio/screens/audio_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AudioRoute.page, initial: true),
  ];
}
