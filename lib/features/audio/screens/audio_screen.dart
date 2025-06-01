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
      appBar: AppBar(
        title: const Text('Lao Instrument Classifier'),
        elevation: 0,
      ),
      body: BlocListener<AudioCubit, AudioState>(
        listener: (context, state) {
          if (state.errors != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errors!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () => context.read<AudioCubit>().clearErrors(),
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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

  Widget _buildStatusCard() {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(state.recordingState),
                      color: _getStatusColor(state.recordingState),
                    ),
                    const SizedBox(width: 8),
                    Text(_getStatusText(state.recordingState)),
                  ],
                ),
                if (state.currentSource != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Source: ${state.currentSource == AudioSource.recording ? "Recording" : "Imported File"}',
                    style: Theme.of(context).textTheme.bodySmall,
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audio Waveform',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: WaveformWidget(
                    waveformData: state.waveformData,
                    color: state.isRecording ? Colors.red : Colors.blue,
                    height: 80,
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
        final audio =
            state.currentSource == AudioSource.recording
                ? state.currentRecording
                : state.selectedFile;

        if (audio == null) return const SizedBox.shrink();

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Audio',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (audio.fileName != null)
                  Row(
                    children: [
                      const Icon(Icons.audiotrack),
                      const SizedBox(width: 8),
                      Expanded(child: Text(audio.fileName!)),
                    ],
                  ),
                if (audio.duration != Duration.zero)
                  Row(
                    children: [
                      const Icon(Icons.timer),
                      const SizedBox(width: 8),
                      Text('${audio.duration.inSeconds} seconds'),
                    ],
                  ),
                if (audio.fileSize != null)
                  Row(
                    children: [
                      const Icon(Icons.storage),
                      const SizedBox(width: 8),
                      Text('${(audio.fileSize! / 1024).toStringAsFixed(1)} KB'),
                    ],
                  ),
                const SizedBox(height: 12),
                if (audio.path != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      final player = ja.AudioPlayer();
                      await player.setFilePath(audio.path);
                      player.play();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPredictButton() {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state.hasAudioData && !state.isUploading
                  ? () => context.read<AudioCubit>().predictInstrument()
                  : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child:
              state.isUploading
                  ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Analyzing...'),
                    ],
                  )
                  : const Text(
                    'Predict Instrument',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
        );
      },
    );
  }

  Widget _buildPredictionResults() {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        if (state.predictionResult == null) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prediction Results',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed:
                          () => context.read<AudioCubit>().clearPrediction(),
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Prediction
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.music_note, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.predictionResult!.instrument,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.trending_up, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Confidence: ${(state.predictionResult!.confidence * 100).toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // All Probabilities
                Text(
                  'All Predictions:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),

                ...state.predictionResult!.allProbabilities.entries
                    .map(
                      (entry) => _buildProbabilityRow(entry.key, entry.value),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProbabilityRow(String instrument, double probability) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(instrument)),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: probability,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                probability > 0.5 ? Colors.green : Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 50,
            child: Text(
              '${(probability * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 12),
            ),
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
