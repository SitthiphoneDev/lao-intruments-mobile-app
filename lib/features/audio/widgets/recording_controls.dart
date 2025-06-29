import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/features/audio/state/audio_cubit.dart';
import '../../../theme/app_colors.dart';


class RecordingSection extends StatelessWidget {
  const RecordingSection({super.key});

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
                'audio.record_title'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 20),

              // Recording Button
              GestureDetector(
                onTap: () => _handleRecordingTap(context, state),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: state.status == AudioStatus.recording
                        ? AppColors.error
                        : AppColors.primaryRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: state.status == AudioStatus.recording
                            ? AppColors.error.withOpacity(0.3)
                            : AppColors.primaryRed.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    state.status == AudioStatus.recording
                        ? Icons.stop
                        : Icons.mic,
                    color: AppColors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Status Text
              Text(
                _getStatusText(state.status),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: state.status == AudioStatus.recording
                      ? AppColors.error
                      : AppColors.darkGrey,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'audio.record_instruction'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              // Recording Timer
              if (state.status == AudioStatus.recording)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _RecordingTimer(),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleRecordingTap(BuildContext context, AudioState state) {
    final cubit = context.read<AudioCubit>();
    
    if (state.status == AudioStatus.recording) {
      cubit.stopRecording();
    } else {
      cubit.startRecording();
    }
  }

  String _getStatusText(AudioStatus status) {
    switch (status) {
      case AudioStatus.recording:
        return 'audio.recording'.tr();
      case AudioStatus.recorded:
        return 'audio.recorded'.tr();
      case AudioStatus.analyzing:
        return 'audio.analyzing'.tr();
      default:
        return 'audio.tap_to_record'.tr();
    }
  }
}

class _RecordingTimer extends StatefulWidget {
  @override
  State<_RecordingTimer> createState() => _RecordingTimerState();
}

class _RecordingTimerState extends State<_RecordingTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        _seconds = (_controller.value * 8).floor();
      });
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: _controller.value,
          backgroundColor: AppColors.lightGrey,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
        ),
        const SizedBox(height: 8),
        Text(
          '${_seconds}s / 8s',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
        ),
      ],
    );
  }
}