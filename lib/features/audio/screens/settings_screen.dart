import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/theme/app_colors.dart';
import 'package:lao_instruments/constants/language_code.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text('settings.title'.tr()),
        backgroundColor: AppColors.darkGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Settings
            _buildSettingsCard(
              title: 'settings.app_settings'.tr(),
              icon: Icons.settings,
              children: [
                _buildLanguageSetting(context),
                // _buildQualitySetting(),
                // _buildThemeSetting(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // History
            const SizedBox(height: 16),
            
            // About
            _buildSettingsCard(
              title: 'settings.about'.tr(),
              icon: Icons.info_outline,
              children: [
                _buildSettingsTile(
                  title: 'settings.app_info'.tr(),
                  subtitle: 'Version 1.0.0',
                  icon: Icons.info,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  title: 'settings.team'.tr(),
                  subtitle: 'settings.team_desc'.tr(),
                  icon: Icons.group,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  title: 'settings.contact'.tr(),
                  subtitle: 'settings.contact_desc'.tr(),
                  icon: Icons.email,
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Help
            _buildSettingsCard(
              title: 'settings.help'.tr(),
              icon: Icons.help_outline,
              children: [
                _buildSettingsTile(
                  title: 'settings.how_to_use'.tr(),
                  subtitle: 'settings.how_to_use_desc'.tr(),
                  icon: Icons.help,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  title: 'settings.feedback'.tr(),
                  subtitle: 'settings.feedback_desc'.tr(),
                  icon: Icons.feedback,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.grey),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSetting(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.language, color: AppColors.grey),
      title: Text(
        'settings.language'.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        context.locale.languageCode == LanguageCode.la ? 'ລາວ' : 'English',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      trailing: Switch(
        value: context.locale.languageCode == LanguageCode.la,
        onChanged: (value) {
          if (value) {
            context.setLocale(const Locale(LanguageCode.la));
          } else {
            context.setLocale(const Locale(LanguageCode.en));
          }
        },
        activeColor: AppColors.primaryRed,
      ),
    );
  }

  Widget _buildQualitySetting() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.high_quality, color: AppColors.grey),
      title: Text(
        'settings.audio_quality'.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        'settings.audio_quality_desc'.tr(),
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: () {
        // TODO: Show quality selection dialog
      },
    );
  }

  Widget _buildThemeSetting() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.palette, color: AppColors.grey),
      title: Text(
        'settings.theme'.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        'settings.theme_desc'.tr(),
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: () {
        // TODO: Show theme selection dialog
      },
    );
  }
}