import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayMantraProvider extends ChangeNotifier {
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool isPlaying = false, isComplete = false;
  Timer? _positionUpdateTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  void setAudioSetting() {
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration = duration;
        notifyListeners();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      currentPosition = position >= totalDuration ? Duration.zero : position;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // todo isComplete = true;
      }
    });
  }

  Future<void> loadAndPlayMusic(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
    notifyListeners();
  }

  Future<void> playPause() async {
    isPlaying = !isPlaying;
    if (isPlaying) {
      _audioPlayer.play();
    } else {
      _audioPlayer.pause();
    }
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return [if (hour > 0) hour, minutes, seconds].map(twoDigits).join(":");
  }

  void disposeAudio() {
    _positionUpdateTimer?.cancel();
    _audioPlayer.dispose();
  }
}
