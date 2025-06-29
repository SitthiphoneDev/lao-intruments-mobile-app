import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/theme/app_colors.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

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
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: AppColors.primaryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'guide.faq_title'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            question: 'guide.faq_1_q'.tr(),
            answer: 'guide.faq_1_a'.tr(),
          ),
          _buildFaqItem(
            question: 'guide.faq_2_q'.tr(),
            answer: 'guide.faq_2_a'.tr(),
          ),
          _buildFaqItem(
            question: 'guide.faq_3_q'.tr(),
            answer: 'guide.faq_3_a'.tr(),
          ),
          _buildFaqItem(
            question: 'guide.faq_4_q'.tr(),
            answer: 'guide.faq_4_a'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.darkGrey,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
    );
  }
}
