import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/theme/app_colors.dart';

class TutorialSection extends StatelessWidget {
  const TutorialSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'guide.tutorial_title'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTutorialStep(
            number: '1',
            title: 'guide.step_1_title'.tr(),
            description: 'guide.step_1_desc'.tr(),
            icon: Icons.phone_android,
          ),
          _buildTutorialStep(
            number: '2',
            title: 'guide.step_2_title'.tr(),
            description: 'guide.step_2_desc'.tr(),
            icon: Icons.mic,
          ),
          _buildTutorialStep(
            number: '3',
            title: 'guide.step_3_title'.tr(),
            description: 'guide.step_3_desc'.tr(),
            icon: Icons.upload_file,
          ),
          _buildTutorialStep(
            number: '4',
            title: 'guide.step_4_title'.tr(),
            description: 'guide.step_4_desc'.tr(),
            icon: Icons.analytics,
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}