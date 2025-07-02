import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/routers/app_router.dart';
import 'package:lao_instruments/theme/app_colors.dart';

@RoutePage()
class MainNavigationScreen extends StatelessWidget implements AutoRouteWrapper {
  const MainNavigationScreen({super.key});
  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) => AutoTabsScaffold(
        routes: const [
          HomeRoute(),
          AudioRoute(),
          GuideRoute(),
          SettingsRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'nav.home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.mic_outlined),
              activeIcon: const Icon(Icons.mic),
              label: 'nav.record'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.help_outline),
              activeIcon: const Icon(Icons.help),
              label: 'nav.guide'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: 'nav.settings'.tr(),
            ),
          ],
        );
      },
    ),
  );
}

}
