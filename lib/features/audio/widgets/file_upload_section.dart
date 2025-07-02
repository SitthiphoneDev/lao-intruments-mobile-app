import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/features/audio/state/audio_cubit.dart';
import '../../../theme/app_colors.dart';
import '../../../generated/locale_keys.g.dart';

class FileUploadSection extends StatelessWidget {
  const FileUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
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
            children: [
              Text(
                LocaleKeys.audio_upload_title.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 20),

              // Upload Button
              GestureDetector(
                onTap: () => context.read<AudioCubit>().pickAudioFile(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryRed,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: state.selectedFile != null
                        ? AppColors.primaryRed.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        state.selectedFile != null
                            ? Icons.check_circle
                            : Icons.upload_file,
                        color: AppColors.primaryRed,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.selectedFile != null
                            ? LocaleKeys.audio_file_selected.tr()
                            : LocaleKeys.audio_tap_to_upload.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.audio_supported_formats_limited.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // File Info
              if (state.selectedFile != null) ...[
                const SizedBox(height: 16),
                _buildFileInfo(state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileInfo(AudioState state) {
    final fileSizeMB = (state.fileSize ?? 0) / (1024 * 1024);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.audiotrack,
                color: AppColors.primaryRed,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.fileName ?? 'Unknown file',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.audio_file_size.tr(args: [fileSizeMB.toStringAsFixed(2)]),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}