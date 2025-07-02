import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_colors.dart';
import '../models/audio_models.dart';

class PredictionResultsSection extends StatefulWidget {
  final PredictionResult result;

  const PredictionResultsSection({
    super.key,
    required this.result,
  });

  @override
  State<PredictionResultsSection> createState() => _PredictionResultsSectionState();
}

class _PredictionResultsSectionState extends State<PredictionResultsSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              
              // Main Result Display (Only the top result)
              _buildMainResult(),
              
              // Confidence Indicator
              _buildConfidenceIndicator(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.analytics,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'audio.results_title'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI Analysis Complete',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Complete',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainResult() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: _getInstrumentGradient(widget.result.instrument),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _getInstrumentColor(widget.result.instrument).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Instrument Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: widget.result.instrument.toLowerCase() != 'unknown'
                    ? Image.asset(
                        'assets/images/instruments/${widget.result.instrument.toLowerCase()}.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _getInstrumentEmoji(widget.result.instrument),
                              style: const TextStyle(fontSize: 48),
                            ),
                          );
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.all(24),
                        child: Icon(
                          Icons.help_outline,
                          size: 48,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Instrument Name
            Text(
              _getInstrumentName(widget.result.instrument),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // English Name
            Text(
              _getInstrumentEnglishName(widget.result.instrument),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Confidence Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getConfidenceIcon(widget.result.confidence),
                    color: AppColors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(widget.result.confidence * 100).toStringAsFixed(1)}% ${'audio.confidence'.tr()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceIndicator() {
    final confidence = widget.result.confidence;
    final isUncertain = confidence < 0.7;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUncertain 
            ? AppColors.warning.withOpacity(0.1)
            : AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUncertain 
              ? AppColors.warning.withOpacity(0.3)
              : AppColors.success.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isUncertain ? Icons.warning_amber : Icons.check_circle,
                color: isUncertain ? AppColors.warning : AppColors.success,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isUncertain ? 'Uncertain Prediction' : 'Confident Prediction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isUncertain ? AppColors.warning : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Confidence Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confidence Level',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Text(
                    '${(confidence * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: confidence,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(confidence),
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          
          if (isUncertain) ...[
            const SizedBox(height: 12),
            Text(
              'audio.uncertain_prediction'.tr(),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGrey,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper methods
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

  String _getInstrumentEnglishName(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return 'Mouth Organ';
      case 'khong_vong':
      case 'khong':
        return 'Gong Circle';
      case 'pin':
        return 'Plucked String';
      case 'ranad':
        return 'Xylophone';
      case 'saw':
      case 'so':
        return 'Bowed String';
      case 'sing':
        return 'Struck Idiophone';
      default:
        return 'Traditional Instrument';
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
        return '🎸';
      case 'ranad':
        return '🎹';
      case 'saw':
      case 'so':
        return '🎻';
      case 'sing':
        return '🔔';
      default:
        return '🎶';
    }
  }

  Color _getInstrumentColor(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return AppColors.primaryBlue;
      case 'khong_vong':
      case 'khong':
        return AppColors.primaryRed;
      case 'pin':
        return AppColors.primaryGold;
      case 'ranad':
        return Colors.purple.shade500;
      case 'saw':
      case 'so':
        return Colors.green.shade500;
      case 'sing':
        return Colors.orange.shade500;
      default:
        return AppColors.grey;
    }
  }

  LinearGradient _getInstrumentGradient(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return AppColors.blueGradient;
      case 'khong_vong':
      case 'khong':
        return AppColors.redGradient;
      case 'pin':
        return AppColors.goldGradient;
      case 'ranad':
        return LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'saw':
      case 'so':
        return LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'sing':
        return LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [AppColors.grey, AppColors.darkGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getConfidenceIcon(double confidence) {
    if (confidence >= 0.9) return Icons.sentiment_very_satisfied;
    if (confidence >= 0.7) return Icons.sentiment_satisfied;
    if (confidence >= 0.5) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppColors.success;
    if (confidence >= 0.6) return AppColors.primaryGold;
    return AppColors.warning;
  }
}