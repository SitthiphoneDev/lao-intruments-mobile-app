import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lao_instruments/constants/enums.dart';
import 'package:lao_instruments/features/audio/state/audio_cubit.dart';

class RecordingControls extends StatelessWidget {
  const RecordingControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Column(
          children: [
            // Recording Progress
            if (state.isRecording || state.recordingState == RecordingState.paused)
              _buildRecordingProgress(state),
            
            const SizedBox(height: 20),
            
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Record Button
                _buildRecordButton(context, state),
                
                // Pause/Resume Button
                if (state.isRecording || state.recordingState == RecordingState.paused)
                  _buildPauseResumeButton(context, state),
                
                // Stop Button
                if (state.recordingState != RecordingState.idle)
                  _buildStopButton(context, state),
                
                // Clear Button
                if (state.hasAudioData)
                  _buildClearButton(context, state),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // File Import Button
            _buildFileImportButton(context, state),
          ],
        );
      },
    );
  }

  Widget _buildRecordingProgress(AudioState state) {
    final progress = state.recordingProgress;
    final currentSeconds = state.recordingDuration.inSeconds;
    final maxSeconds = state.maxRecordingDuration.inSeconds;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.8 ? Colors.red : Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$currentSeconds / $maxSeconds seconds',
          style: TextStyle(
            color: progress > 0.8 ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton(BuildContext context, AudioState state) {
    return FloatingActionButton(
      onPressed: state.canRecord
          ? () => context.read<AudioCubit>().startRecording()
          : () => context.read<AudioCubit>().startRecording(),
      backgroundColor: state.canRecord ? Colors.red : Colors.grey,
      child: Icon(
        state.isRecording ? Icons.mic : Icons.mic_none,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPauseResumeButton(BuildContext context, AudioState state) {
    return FloatingActionButton(
      onPressed: state.recordingState == RecordingState.recording
          ? () => context.read<AudioCubit>().pauseRecording()
          : () => context.read<AudioCubit>().resumeRecording(),
      backgroundColor: Colors.orange,
      child: Icon(
        state.recordingState == RecordingState.recording
            ? Icons.pause
            : Icons.play_arrow,
        color: Colors.white,
      ),
    );
  }

  Widget _buildStopButton(BuildContext context, AudioState state) {
    return FloatingActionButton(
      onPressed: () => context.read<AudioCubit>().stopRecording(),
      backgroundColor: Colors.grey[700],
      child: const Icon(Icons.stop, color: Colors.white),
    );
  }

  Widget _buildClearButton(BuildContext context, AudioState state) {
    return FloatingActionButton(
      onPressed: () {
        if (state.currentSource == AudioSource.recording) {
          context.read<AudioCubit>().clearRecording();
        } else {
          context.read<AudioCubit>().clearSelectedFile();
        }
      },
      backgroundColor: Colors.red[300],
      child: const Icon(Icons.clear, color: Colors.white),
    );
  }

  Widget _buildFileImportButton(BuildContext context, AudioState state) {
    return ElevatedButton.icon(
      onPressed: state.isLoading
          ? null
          : () => context.read<AudioCubit>().selectAudioFile(),
      icon: state.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.file_upload),
      label: const Text('Import Audio File'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
