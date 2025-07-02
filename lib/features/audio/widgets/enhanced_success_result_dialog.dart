import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:lao_instruments/generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../models/audio_models.dart';
import '../constants/instrument_data.dart';

class EnhancedSuccessResultDialog extends StatefulWidget {
  final PredictionResult result;
  final VoidCallback onViewFullDetails;
  final VoidCallback onLearnMore;
  final VoidCallback? onShareResult;

  const EnhancedSuccessResultDialog({
    super.key,
    required this.result,
    required this.onViewFullDetails,
    required this.onLearnMore,
    this.onShareResult,
  });

  @override
  State<EnhancedSuccessResultDialog> createState() => _EnhancedSuccessResultDialogState();
}

class _EnhancedSuccessResultDialogState extends State<EnhancedSuccessResultDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Play success effects
    _playSuccessEffects();
  }

  void _playSuccessEffects() async {
    // Play system sound
    SystemSound.play(SystemSoundType.click);
    
    // Start animations
    _animationController.forward();
    
    // Start pulse animation after main animation
    await Future.delayed(const Duration(milliseconds: 600));
    _pulseController.repeat(reverse: true);
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instrumentData = InstrumentData.getInstrumentData(widget.result.instrument);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.1,
            ),
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.7,
                    maxWidth: screenWidth * 0.9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with gradient background
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: _getInstrumentGradient(widget.result.instrument),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Close button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'audio.analysis_complete'.tr(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context.maybePop(),
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 10),
                            
                            // Success Icon with pulse animation
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: AppColors.white,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Content area
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Instrument Image and Info
                              _buildInstrumentImageSection(instrumentData),
                              
                              const SizedBox(height: 20),
                              
                              // Confidence Section
                              _buildConfidenceSection(),
                              
                              const SizedBox(height: 20),

                              // Action Buttons
                              _buildActionButtons(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstrumentImageSection(Map<String, dynamic> instrumentData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getInstrumentGradient(widget.result.instrument).colors.first.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Instrument Image
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _buildInstrumentImage(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Instrument Names
          Text(
            instrumentData['name_lao'] ?? _getInstrumentName(widget.result.instrument),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          Text(
            instrumentData['name_english'] ?? widget.result.instrument.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInstrumentImage() {
    final instrumentId = widget.result.instrument.toLowerCase();
    
    // Try to load actual image, fallback to emoji
    return FutureBuilder<bool>(
      future: _checkImageExists(instrumentId),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.asset(
            'assets/images/instruments/${instrumentId}.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildEmojiImage();
            },
          );
        } else {
          return _buildEmojiImage();
        }
      },
    );
  }

  Widget _buildEmojiImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: _getInstrumentGradient(widget.result.instrument).scale(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          _getInstrumentEmoji(widget.result.instrument),
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }

  Future<bool> _checkImageExists(String instrumentId) async {
    try {
      await rootBundle.load('assets/images/instruments/${instrumentId}.jpg');
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildConfidenceSection() {
    final confidence = widget.result.confidence;
    final confidencePercent = confidence * 100;
    
    Color confidenceColor;
    IconData confidenceIcon;
    String confidenceText;
    
    if (confidence > 0.8) {
      confidenceColor = AppColors.success;
      confidenceIcon = Icons.verified;
      confidenceText = 'audio.very_high_confidence'.tr();
    } else if (confidence > 0.6) {
      confidenceColor = AppColors.primaryGold;
      confidenceIcon = Icons.thumb_up;
      confidenceText = 'audio.high_confidence'.tr();
    } else if (confidence > 0.4) {
      confidenceColor = AppColors.warning;
      confidenceIcon = Icons.help_outline;
      confidenceText = 'audio.medium_confidence'.tr();
    } else {
      confidenceColor = AppColors.error;
      confidenceIcon = Icons.warning;
      confidenceText = 'audio.low_confidence'.tr();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: confidenceColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: confidenceColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(confidenceIcon, color: confidenceColor, size: 24),
              const SizedBox(width: 8),
              Text(
                confidenceText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: confidenceColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Confidence Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: confidence,
              child: Container(
                decoration: BoxDecoration(
                  color: confidenceColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${confidencePercent.toStringAsFixed(1)}% ${'audio.confidence'.tr()}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: confidenceColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary Actions
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onViewFullDetails,
                icon: const Icon(Icons.analytics, color: AppColors.white),
                label: Text(
                  LocaleKeys.audio_view_details.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onLearnMore,
                icon: const Icon(Icons.school, color: AppColors.white),
                label: Text(
                  'audio.learn_more'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Helper methods
  LinearGradient _getInstrumentGradient(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return AppColors.goldGradient;
      case 'khong_vong':
      case 'khong':
        return AppColors.blueGradient;
      case 'pin':
        return const LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'ranad':
        return const LinearGradient(
          colors: [Color(0xFF228B22), Color(0xFF32CD32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'saw':
      case 'so':
        return const LinearGradient(
          colors: [Color(0xFF4B0082), Color(0xFF8A2BE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'sing':
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
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

  String _getShortDescription(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return 'Traditional Lao mouth organ made of bamboo pipes with metal reeds. UNESCO recognized heritage instrument.';
      case 'khong_vong':
      case 'khong':
        return 'Circular arrangement of bronze gongs used in traditional Lao orchestras for melodic lines.';
      case 'pin':
        return 'Plucked string instrument with coconut resonator, similar to a lute, used in folk music.';
      case 'ranad':
        return 'Wooden xylophone with bamboo resonators, producing bright percussive tones.';
      case 'saw':
      case 'so':
        return 'Two-stringed bowed instrument that can imitate the human voice with expressive tones.';
      case 'sing':
        return 'Small cymbals used for rhythmic accompaniment, providing structure in ensemble performances.';
      default:
        return 'Traditional Lao musical instrument with unique characteristics and cultural significance.';
    }
  }
}