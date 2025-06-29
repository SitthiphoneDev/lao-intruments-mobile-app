import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:just_audio/just_audio.dart';
import '../../../theme/app_colors.dart';

class AudioWaveformWidget extends StatefulWidget {
  final String? audioPath;

  const AudioWaveformWidget({
    super.key,
    this.audioPath,
  });

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() async {
    if (widget.audioPath != null) {
      try {
        await _audioPlayer.setFilePath(widget.audioPath!);
        
        _audioPlayer.durationStream.listen((duration) {
          setState(() {
            _duration = duration ?? Duration.zero;
          });
        });

        _audioPlayer.positionStream.listen((position) {
          setState(() {
            _position = position;
          });
        });

        _audioPlayer.playerStateStream.listen((state) {
          setState(() {
            _isPlaying = state.playing;
          });
        });
      } catch (e) {
        print('Error setting up audio player: $e');
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioPath == null) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'audio.audio_preview'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          
          // Waveform placeholder (simple bars)
          _buildSimpleWaveform(),
          
          const SizedBox(height: 16),
          
          // Audio controls
          Row(
            children: [
              IconButton(
                onPressed: _togglePlayback,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.primaryRed,
                  size: 32,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: _duration.inMilliseconds > 0 
                          ? _position.inMilliseconds / _duration.inMilliseconds 
                          : 0,
                      backgroundColor: AppColors.lightGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
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

  Widget _buildSimpleWaveform() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(20, (index) {
          final height = 20.0 + (index % 4) * 10 + (index % 7) * 5;
          final isActive = _duration.inMilliseconds > 0 
              ? (index / 20) <= (_position.inMilliseconds / _duration.inMilliseconds)
              : false;
          
          return Container(
            width: 3,
            height: height,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryRed : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  void _togglePlayback() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error toggling playback: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}