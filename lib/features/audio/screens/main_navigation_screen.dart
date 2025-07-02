import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/routers/app_router.dart';
import 'package:lao_instruments/theme/app_colors.dart';
import 'package:lao_instruments/generated/locale_keys.g.dart';

@RoutePage()
class MainNavigationScreen extends StatelessWidget implements AutoRouteWrapper {
  const MainNavigationScreen({super.key});
  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        AudioRoute(),
        GuideRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final isHomeScreen = tabsRouter.activeIndex == 0;
        
        return Scaffold(
          // Now we can dynamically set extendBody based on current screen!
          extendBody: isHomeScreen,
          body: child,
          bottomNavigationBar: isHomeScreen
              ? _buildHomeNavigationBar(context, tabsRouter)
              : _buildDefaultNavigationBar(context, tabsRouter),
        );
      },
    );
  }

  /// Builds the modern, transparent "frosted glass" navigation bar for the Home page.
  Widget _buildHomeNavigationBar(BuildContext context, TabsRouter tabsRouter) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 12,
                fontFamily: 'Inter',
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal, 
                fontSize: 12,
                fontFamily: 'Inter',
              ),
              items: _navBarItems(context),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the original, solid white navigation bar for all other pages.
  Widget _buildDefaultNavigationBar(BuildContext context, TabsRouter tabsRouter) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 12,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal, 
          fontSize: 12,
          fontFamily: 'Inter',
        ),
        items: _navBarItems(context),
      ),
    );
  }

  /// Helper method to avoid duplicating the list of items with proper LocaleKeys.
  List<BottomNavigationBarItem> _navBarItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: LocaleKeys.nav_home.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.mic_outlined),
        activeIcon: const Icon(Icons.mic),
        label: LocaleKeys.nav_record.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.help_outline),
        activeIcon: const Icon(Icons.help),
        label: LocaleKeys.nav_guide.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings_outlined),
        activeIcon: const Icon(Icons.settings),
        label: LocaleKeys.nav_settings.tr(),
      ),
    ];
  }
}