import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lao_instruments/DI/service_locator.dart';
import 'package:lao_instruments/constants/enums.dart';
import 'package:lao_instruments/features/audio/state/audio_cubit.dart';

import '../widgets/waveform_widget.dart';
import '../widgets/recording_controls.dart';

@RoutePage()
class AudioScreen extends StatelessWidget implements AutoRouteWrapper {
  const AudioScreen({super.key});
  
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AudioCubit>()..initialize()),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: BlocListener<AudioCubit, AudioState>(
        listener: (context, state) {
          if (state.errors != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errors!)),
                  ],
                ),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () => context.read<AudioCubit>().clearErrors(),
                ),
              ),
            );
          }
          if (state.recordingState == RecordingState.completed && 
        state.hasAudioData && 
        !state.isUploading &&
        state.predictionResult == null) {
      
      // Show auto-predict notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text('Auto-analyzing recording...'),
            ],
          ),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Trigger auto-prediction
      context.read<AudioCubit>().predictInstrument();
    }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info
              _buildHeaderInfo(),
              
              const SizedBox(height: 20),

              // Status Card
              _buildStatusCard(),

              const SizedBox(height: 20),

              // Waveform Display
              _buildWaveformSection(),

              const SizedBox(height: 20),

              // Recording Controls
              const RecordingControls(),

              const SizedBox(height: 20),

              // Current Audio Info
              _buildCurrentAudioInfo(),

              const SizedBox(height: 20),

              // Predict Button
              _buildPredictButton(),

              const SizedBox(height: 20),

              // Prediction Results
              _buildPredictionResults(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.music_note, color: Colors.white),
          SizedBox(width: 8),
          Text('Lao Instrument Classifier'),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showInfoDialog(context),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎵 AI-Powered Recognition',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Identify traditional Lao musical instruments using advanced machine learning',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildStatusCard() {
  return BlocBuilder<AudioCubit, AudioState>(
    builder: (context, state) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.radio_button_checked, color: Colors.deepPurple[600]),
                  const SizedBox(width: 8),
                  Text(
                    'System Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[600],
                    ),
                  ),
                  // Show auto-predict indicator
                  if (state.recordingState == RecordingState.completed && state.predictionResult != null)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 12, color: Colors.green[700]),
                          const SizedBox(width: 2),
                          Text(
                            'AUTO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(state.recordingState).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(state.recordingState).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(state.recordingState),
                      color: _getStatusColor(state.recordingState),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getStatusText(state.recordingState),
                        style: TextStyle(
                          color: _getStatusColor(state.recordingState),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Show auto-predict status
                    if (state.recordingState == RecordingState.completed && 
                        state.predictionResult != null)
                      Text(
                        '• Auto-analyzed',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              if (state.currentSource != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        state.currentSource == AudioSource.recording 
                          ? Icons.mic 
                          : Icons.file_upload,
                        size: 16,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Source: ${state.currentSource == AudioSource.recording ? "Recording" : "Imported File"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildWaveformSection() {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.graphic_eq, color: Colors.deepPurple[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Audio Waveform',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[100]!, Colors.grey[50]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: WaveformWidget(
                      waveformData: state.waveformData,
                      color: state.isRecording 
                        ? Colors.red[600]! 
                        : Colors.deepPurple[600]!,
                      height: 100,
                    ),
                  ),
                ),
                if (state.waveformData.isEmpty)
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.graphic_eq, size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'No audio data',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentAudioInfo() {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        final audio = state.currentSource == AudioSource.recording
            ? state.currentRecording
            : state.selectedFile;

        if (audio == null) return const SizedBox.shrink();

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.audiotrack, color: Colors.deepPurple[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Current Audio',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Audio Details
                if (audio.fileName != null)
                  _buildInfoRow(Icons.music_note, 'File', audio.fileName!),
                
                if (audio.duration != Duration.zero)
                  _buildInfoRow(Icons.timer, 'Duration', '${audio.duration.inSeconds} seconds'),
                
                if (audio.fileSize != null)
                  _buildInfoRow(Icons.storage, 'Size', '${(audio.fileSize! / 1024).toStringAsFixed(1)} KB'),
                
                const SizedBox(height: 16),
                
                // Play Button
                if (audio.path != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play Audio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final player = ja.AudioPlayer();
                          await player.setFilePath(audio.path!);
                          await player.play();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error playing audio: $e'),
                                backgroundColor: Colors.red[600],
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPredictButton() {
  return BlocBuilder<AudioCubit, AudioState>(
    builder: (context, state) {
      final isEnabled = state.hasAudioData && !state.isUploading;
      final hasResult = state.predictionResult != null;
      
      return Container(
        decoration: BoxDecoration(
          gradient: isEnabled 
            ? LinearGradient(
                colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: ElevatedButton(
          onPressed: isEnabled 
            ? () => context.read<AudioCubit>().predictInstrument()
            : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state.isUploading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Analyzing Audio...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasResult ? Icons.refresh : Icons.auto_awesome,
                    color: isEnabled ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    hasResult ? 'Re-analyze Audio' : 'Predict Instrument',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.white : Colors.grey,
                    ),
                  ),
                  if (hasResult && state.recordingState == RecordingState.completed)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'AUTO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
        ),
      );
    },
  );
}

  Widget _buildPredictionResults() {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        if (state.predictionResult == null) return const SizedBox.shrink();

        final result = state.predictionResult!;
        
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Prediction Results',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.read<AudioCubit>().clearPrediction(),
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // Main Prediction Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.green[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.music_note, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getInstrumentDisplayName(result.instrument),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              result.confidenceCategory,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Uncertainty Warning
                if (result.isUncertain)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Uncertain prediction - consider recording in a quieter environment',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (result.isUncertain) const SizedBox(height: 16),

                // Detailed Metrics
                Row(
                  children: [
                    Icon(Icons.insights, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Detailed Analysis',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                // Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Segments',
                        '${result.segmentsUsed}',
                        Icons.graphic_eq,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        'Entropy',
                        result.entropy.toStringAsFixed(2),
                        Icons.scatter_plot,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        'Time',
                        '${result.processingTimeMs.toStringAsFixed(0)}ms',
                        Icons.timer,
                        Colors.teal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // All Probabilities
                Row(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      'All Predictions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                // Sort probabilities by value
                ...(() {
                  final entries = result.probabilities.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  return entries
                      .map((entry) => _buildProbabilityRow(entry.key, entry.value))
                      .toList();
                })(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilityRow(String instrument, double probability) {
    final isTopPrediction = probability > 0.3;
    final displayName = _getInstrumentDisplayName(instrument);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTopPrediction ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTopPrediction ? Colors.blue[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getInstrumentIcon(instrument),
            color: isTopPrediction ? Colors.blue[600] : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              displayName,
              style: TextStyle(
                fontWeight: isTopPrediction ? FontWeight.bold : FontWeight.normal,
                color: isTopPrediction ? Colors.blue[700] : Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: probability,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isTopPrediction ? Colors.blue[600]! : Colors.grey[500]!,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text(
              '${(probability * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isTopPrediction ? Colors.blue[700] : Colors.grey[600],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _getInstrumentDisplayName(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
        return '🎵 Khaen (ແຄນ)';
      case 'khong_vong':
        return '🥁 Khong Wong (ຄ້ອງວົງ)';
      case 'pin':
        return '🎸 Pin (ພິນ)';
      case 'ranad':
        return '🎹 Ranad (ລະນາດ)';
      case 'saw':
        return '🎻 So U (ຊໍອູ້)';
      case 'sing':
        return '🥁 Sing (ຊິ່ງ)';
      case 'unknown':
        return '❓ Unknown Sound';
      default:
        return '🎵 ${instrument.replaceAll('_', ' ').toUpperCase()}';
    }
  }

  IconData _getInstrumentIcon(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
        return Icons.air;
      case 'khong_vong':
        return Icons.radio_button_on;
      case 'pin':
        return Icons.music_note;
      case 'ranad':
        return Icons.piano;
      case 'saw':
        return Icons.graphic_eq;
      case 'sing':
        return Icons.album;
      case 'unknown':
        return Icons.help_outline;
      default:
        return Icons.music_note;
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('About This App'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This AI-powered app recognizes traditional Lao musical instruments:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('• Khaen (ແຄນ) - Mouth organ'),
            Text('• Khong Wong (ຄ້ອງວົງ) - Gong circle'),
            Text('• Pin (ພິນ) - Plucked string instrument'),
            Text('• Ranad (ລະນາດ) - Wooden xylophone'),
            Text('• So U (ຊໍອູ້) - Bowed string instrument'),
            Text('• Sing (ຊິ່ງ) - Small cymbals'),
            SizedBox(height: 12),
            Text(
              'For best results:\n• Record clear, isolated instrument sounds\n• Minimize background noise\n• Record for at least 3-4 seconds',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(RecordingState state) {
    switch (state) {
      case RecordingState.idle:
        return Icons.mic_none;
      case RecordingState.recording:
        return Icons.mic;
      case RecordingState.paused:
        return Icons.pause;
      case RecordingState.completed:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor(RecordingState state) {
    switch (state) {
      case RecordingState.idle:
        return Colors.grey;
      case RecordingState.recording:
        return Colors.red;
      case RecordingState.paused:
        return Colors.orange;
      case RecordingState.completed:
        return Colors.green;
    }
  }

  String _getStatusText(RecordingState state) {
    switch (state) {
      case RecordingState.idle:
        return 'Ready to record';
      case RecordingState.recording:
        return 'Recording...';
      case RecordingState.paused:
        return 'Recording paused';
      case RecordingState.completed:
        return 'Recording completed';
    }
  }
}