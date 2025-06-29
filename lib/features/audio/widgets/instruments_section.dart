import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/theme/app_colors.dart';

class InstrumentsSection extends StatelessWidget {
  const InstrumentsSection({super.key});

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
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.library_music,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'guide.instruments_title'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstrumentCard('🎵', 'ແຄນ (Khaen)', 'guide.khaen_desc'.tr()),
          _buildInstrumentCard('🥁', 'ຄ້ອງວົງ (Khong Wong)', 'guide.khong_desc'.tr()),
          _buildInstrumentCard('🪕', 'ພິນ (Pin)', 'guide.pin_desc'.tr()),
          _buildInstrumentCard('🎹', 'ລະນາດ (Ranad)', 'guide.ranad_desc'.tr()),
          _buildInstrumentCard('🎻', 'ຊໍອູ້ (So U)', 'guide.so_desc'.tr()),
          _buildInstrumentCard('🥁', 'ຊິ່ງ (Sing)', 'guide.sing_desc'.tr()),
        ],
      ),
    );
  }

  Widget _buildInstrumentCard(String emoji, String name, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
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
