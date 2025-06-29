import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import '../../../theme/app_colors.dart';
import '../state/audio_cubit.dart';

class EnhancedFileUploadSection extends StatelessWidget {
  const EnhancedFileUploadSection({super.key});

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
                'audio.upload_title'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 20),

              // Upload Button
              GestureDetector(
                onTap: () => _pickAudioFileWithLimits(context),
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
                            ? 'audio.file_selected'.tr()
                            : 'audio.tap_to_upload'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // UPDATED: Only WAV and MP3
                      Text(
                        'audio.supported_formats_limited'.tr(), // "WAV, MP3 only (max 10s)"
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

  // Enhanced file picker with limitations
  Future<void> _pickAudioFileWithLimits(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav', 'mp3'], // ONLY WAV and MP3
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        // Check file size (10MB max for safety)
        if (fileSize > 10 * 1024 * 1024) {
          _showErrorDialog(context, 'audio.file_too_large'.tr());
          return;
        }

        // Check audio duration (will be checked after loading)
        context.read<AudioCubit>().pickAudioFileWithValidation(file, fileName, fileSize);
      }
    } catch (e) {
      _showErrorDialog(context, 'audio.file_error'.tr());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('audio.error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('audio.ok'.tr()),
          ),
        ],
      ),
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
          Row(
            children: [
              Text(
                'audio.file_size'.tr(args: [fileSizeMB.toStringAsFixed(2)]),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              if (state.audioDuration != null)
                Text(
                  'audio.duration'.tr(args: [state.audioDuration!.toStringAsFixed(1)]),
                  style: TextStyle(
                    fontSize: 12,
                    color: state.audioDuration! > 10.0 ? AppColors.error : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          if (state.audioDuration != null && state.audioDuration! > 10.0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'audio.duration_warning'.tr(), // "Audio longer than 10s may affect accuracy"
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}