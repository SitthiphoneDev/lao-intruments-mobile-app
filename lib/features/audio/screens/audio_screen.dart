import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:lao_instruments/features/audio/models/audio_models.dart';
import 'package:lao_instruments/features/audio/screens/detailed_instrument_screen.dart';
import 'package:lao_instruments/features/audio/state/audio_cubit.dart';
import 'package:lao_instruments/features/audio/widgets/audio_waveform_widget.dart';
import 'package:lao_instruments/features/audio/widgets/enhanced_file_upload_section.dart';
import 'package:lao_instruments/features/audio/widgets/enhanced_success_result_dialog.dart';
import 'package:lao_instruments/features/audio/widgets/prediction_results_section.dart';
import 'package:lao_instruments/features/audio/widgets/recording_controls.dart';
import 'package:lao_instruments/generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';

@RoutePage()
class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<AudioCubit>(),
      child: const _AudioScreenView(),
    );
  }
}

class _AudioScreenView extends StatefulWidget {
  const _AudioScreenView();

  @override
  State<_AudioScreenView> createState() => _AudioScreenViewState();
}

class _AudioScreenViewState extends State<_AudioScreenView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late ScrollController _scrollController;
  
  int _currentPage = 0;
  bool _showFab = false;
  String? _lastResultId; // Track last result to prevent duplicates

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioCubit, AudioState>(
      listener: (context, state) {
        // Error handling
        if (state.status == AudioStatus.failure && state.errors != null) {
          _showErrorSnackBar(context, state.errors!);
        }
        
        // Success handling - Auto navigate to results page and show dialog
        if (state.status == AudioStatus.success && state.predictionResult != null) {
          // Check for duplicates
          final resultId = '${state.predictionResult!.instrument}_${state.predictionResult!.confidence}';
          if (_lastResultId == resultId) return;
          _lastResultId = resultId;
          
          // Check if it's unknown instrument
          if (state.predictionResult!.instrument.toLowerCase() == 'unknown') {
            _showUnknownInstrumentDialog(state.predictionResult!);
          } else {
            // First navigate to results page
            _navigateToPage(1);
            // Then show success dialog after a brief delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                _showEnhancedSuccessDialog(state.predictionResult!);
              }
            });
          }
        }

        // Auto scroll to analyzing indicator when analysis starts
        if (state.status == AudioStatus.analyzing) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && _scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
              );
            }
          });
        }

        // Show/hide FAB based on results
        final shouldShowFab = state.predictionResult != null;
        if (shouldShowFab != _showFab) {
          setState(() {
            _showFab = shouldShowFab;
          });
          if (shouldShowFab) {
            _fabAnimationController.forward();
          } else {
            _fabAnimationController.reverse();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.lightGrey,
          appBar: _buildAppBar(context, state),
          body: Column(
            children: [
              // Custom Tab Bar
              _buildCustomTabBar(),
              
              // Page Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    _buildRecordingPage(state),
                    _buildResultsPage(state),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: const SizedBox.shrink(), // Removed FAB
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AudioState state) {
    return AppBar(
      title: Text('audio.title'.tr()),
      backgroundColor: AppColors.primaryRed,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<AudioCubit>().reset();
            _navigateToPage(0);
          },
          tooltip: LocaleKeys.audio_reset.tr(),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAppInfo(context),
          tooltip: LocaleKeys.audio_app_info.tr(),
        ),
      ],
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
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
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              index: 0,
              icon: Icons.mic,
              label: LocaleKeys.audio_record_tab.tr(),
              isActive: _currentPage == 0,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              index: 1,
              icon: Icons.analytics,
              label: LocaleKeys.audio_results_tab.tr(),
              isActive: _currentPage == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _navigateToPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.redGradient : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.white : AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.white : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(AudioState state) {
    if (!_showFab || state.predictionResult == null) {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: () => _navigateToDetailedInstrumentScreen(state.predictionResult!),
        backgroundColor: AppColors.primaryGold,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.school),
        label: Text(LocaleKeys.audio_learn_more.tr()),
      ),
    );
  }

  // Page 1: Recording Interface
  Widget _buildRecordingPage(AudioState state) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Instructions Card
          _buildEnhancedInstructionsCard(),
          const SizedBox(height: 20),

          // Recording Section
          const RecordingSection(),
          const SizedBox(height: 20),

          // Enhanced File Upload Section
          const EnhancedFileUploadSection(),
          const SizedBox(height: 20),

          // Audio Waveform with enhanced styling
          if (state.recordingPath != null || state.selectedFile != null)
            _buildEnhancedAudioSection(state),

          if (state.recordingPath != null || state.selectedFile != null)
            const SizedBox(height: 20),

          // Enhanced Loading Indicator
          if (state.status == AudioStatus.analyzing)
            _buildEnhancedAnalyzingIndicator(),

          // Quick action to view last result
          if (state.predictionResult != null && _currentPage == 0)
            _buildQuickResultPreview(state.predictionResult!),
        ],
      ),
    );
  }

  // Page 2: Results Interface
  Widget _buildResultsPage(AudioState state) {
    if (state.predictionResult == null) {
      return _buildNoResultsPage();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detailed Results (Main component)
          PredictionResultsSection(
            result: state.predictionResult!,
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          _buildResultActionButtons(state.predictionResult!),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNoResultsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 80,
              color: AppColors.grey.withOpacity(0.5),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            LocaleKeys.audio_no_results_title.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            LocaleKeys.audio_no_results_desc.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: () => _navigateToPage(0),
            icon: const Icon(Icons.mic, color: AppColors.white),
            label: Text(
              LocaleKeys.audio_start_recording.tr(),
              style: const TextStyle(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickResultPreview(PredictionResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.celebration, color: AppColors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.audio_latest_result.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _navigateToPage(1),
                child: const Icon(Icons.arrow_forward, color: AppColors.white),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            _getInstrumentName(result.instrument),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              LocaleKeys.audio_confidence_percent.tr(args: [(result.confidence * 100).toStringAsFixed(1)]),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultHeaderCard(PredictionResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _getInstrumentGradient(result.instrument),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _getInstrumentEmoji(result.instrument),
                  style: const TextStyle(fontSize: 32),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      _getInstrumentName(result.instrument),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        LocaleKeys.audio_confidence_percent.tr(args: [(result.confidence * 100).toStringAsFixed(1)]),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultActionButtons(PredictionResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.audio_actions.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          
          // Learn More Button (Full Width)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToDetailedInstrumentScreen(result),
              icon: const Icon(Icons.school, color: AppColors.white),
              label: Text(
                LocaleKeys.audio_learn_more.tr(),
                style: const TextStyle(color: AppColors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Try Another Recording Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<AudioCubit>().reset();
                _lastResultId = null; // Reset duplicate prevention
                _navigateToPage(0);
              },
              icon: const Icon(Icons.refresh, color: AppColors.white),
              label: Text(
                LocaleKeys.audio_try_another.tr(),
                style: const TextStyle(color: AppColors.white),
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
        ],
      ),
    );
  }

  Widget _buildEnhancedInstructionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.darkGrey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'audio.instructions_title'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    Text(
                      LocaleKeys.audio_instructions_subtitle.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEnhancedInstructionItem('🎙️', LocaleKeys.audio_instruction_1.tr()),
          _buildEnhancedInstructionItem('🔇', LocaleKeys.audio_instruction_2.tr()),
          _buildEnhancedInstructionItem('⏱️', LocaleKeys.audio_instruction_3.tr())
        ],
      ),
    );
  }

  Widget _buildEnhancedInstructionItem(String emoji, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAudioSection(AudioState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.audiotrack, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'audio.audio_preview'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        state.fileName ?? LocaleKeys.audio_recorded_audio.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.audioDuration != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      LocaleKeys.audio_duration_seconds.tr(args: [state.audioDuration!.toStringAsFixed(1)]),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Waveform
          AudioWaveformWidget(
            audioPath: state.recordingPath ?? state.selectedFile?.path,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAnalyzingIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated AI Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology,
              color: AppColors.white,
              size: 48,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Progress indicator
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              minHeight: 6,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'audio.analyzing'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'audio.analyzing_desc'.tr(),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // All your existing helper methods...
  void _showUnknownInstrumentDialog(PredictionResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.help_outline,
                color: AppColors.warning,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              LocaleKeys.audio_unknown_instrument.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🤔',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.audio_unknown_message.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.audio_unknown_reasons.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.primaryGold, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      LocaleKeys.audio_unknown_tip.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToPage(1); // Still show results
            },
            child: Text(
              LocaleKeys.audio_view_details.tr(),
              style: const TextStyle(color: AppColors.primaryBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AudioCubit>().reset();
              _lastResultId = null; // Reset duplicate prevention
              _navigateToPage(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              LocaleKeys.audio_try_again.tr(),
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEnhancedSuccessDialog(PredictionResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EnhancedSuccessResultDialog(
        result: result,
        onViewFullDetails: () {
          Navigator.of(context).pop();
        },
        onLearnMore: () {
          Navigator.of(context).pop();
          _navigateToDetailedInstrumentScreen(result);
        },
        onShareResult: () {
          Navigator.of(context).pop();
          _shareResult(result);
        },
      ),
    );
  }

  void _navigateToDetailedInstrumentScreen(PredictionResult result) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedInstrumentScreen(
          instrumentId: result.instrument,
          predictionResult: result,
        ),
      ),
    );
  }

  void _shareResult(PredictionResult result) {
    final instrumentName = _getInstrumentName(result.instrument);
    final confidence = (result.confidence * 100).toStringAsFixed(1);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.audio_sharing_result.tr(args: [instrumentName, confidence])),
        backgroundColor: AppColors.primaryBlue,
        action: SnackBarAction(
          label: LocaleKeys.audio_share.tr(),
          textColor: AppColors.white,
          onPressed: () {
            // TODO: Implement actual sharing functionality
          },
        ),
      ),
    );
  }

  String _getInstrumentName(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return LocaleKeys.instrument_khaen_name.tr();
      case 'khong_vong':
      case 'khong':
        return LocaleKeys.instrument_khong_name.tr();
      case 'pin':
        return LocaleKeys.instrument_pin_name.tr();
      case 'ranad':
        return LocaleKeys.instrument_ranad_name.tr();
      case 'saw':
      case 'so':
        return LocaleKeys.instrument_so_name.tr();
      case 'sing':
        return LocaleKeys.instrument_sing_name.tr();
      case 'unknown':
        return LocaleKeys.instrument_unknown_name.tr();
      default:
        return instrument;
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

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: LocaleKeys.audio_retry.tr(),
          textColor: AppColors.white,
          onPressed: () => context.read<AudioCubit>().reset(),
        ),
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Text(LocaleKeys.audio_app_info.tr()),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.audio_app_name.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(LocaleKeys.audio_app_version.tr()),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.audio_app_description.tr(),
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.audio_supported_instruments.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(LocaleKeys.audio_instruments_list.tr()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.audio_close.tr()),
          ),
        ],
      ),
    );
  }
}