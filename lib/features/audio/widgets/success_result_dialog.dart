import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';
import '../models/audio_models.dart';

class SuccessResultDialog extends StatefulWidget {
  final PredictionResult result;
  final VoidCallback onViewDetails;
  final VoidCallback onLearnMore;

  const SuccessResultDialog({
    super.key,
    required this.result,
    required this.onViewDetails,
    required this.onLearnMore,
  });

  @override
  State<SuccessResultDialog> createState() => _SuccessResultDialogState();
}

class _SuccessResultDialogState extends State<SuccessResultDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Play success sound and animation
    _playSuccessEffects();
  }

  void _playSuccessEffects() async {
    // Play system sound
    SystemSound.play(SystemSoundType.click);
    
    // Start animation
    _animationController.forward();
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 48,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      'audio.analysis_complete'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Result
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: _getInstrumentGradient(widget.result.instrument),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getInstrumentEmoji(widget.result.instrument),
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getInstrumentName(widget.result.instrument),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            '${(widget.result.confidence * 100).toStringAsFixed(1)}% ${'audio.confidence'.tr()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: widget.onViewDetails,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.grey,
                            ),
                            child: Text('audio.view_details'.tr()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onLearnMore,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                            ),
                            child: Text('audio.learn_more'.tr()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getInstrumentGradient(String instrument) {
    // Same as in prediction_results_section.dart
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return AppColors.goldGradient;
      case 'khong_vong':
      case 'khong':
        return AppColors.blueGradient;
      default:
        return AppColors.redGradient;
    }
  }

  String _getInstrumentEmoji(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return '🎵';
      case 'khong_vong':
      case 'khong':
        return '🥁';
      case 'pin':
        return '🪕';
      case 'ranad':
        return '🎹';
      case 'saw':
      case 'so':
        return '🎻';
      case 'sing':
        return '🥁';
      default:
        return '❓';
    }
  }

  String _getInstrumentName(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return 'ແຄນ (Khaen)';
      case 'khong_vong':
      case 'khong':
        return 'ຄ້ອງວົງ (Khong Wong)';
      case 'pin':
        return 'ພິນ (Pin)';
      case 'ranad':
        return 'ລະນາດ (Ranad)';
      case 'saw':
      case 'so':
        return 'ຊໍອູ້ (So U)';
      case 'sing':
        return 'ຊິ່ງ (Sing)';
      case 'unknown':
        return 'ບໍ່ຮູ້ຈັກ (Unknown)';
      default:
        return instrument;
    }
  }
}