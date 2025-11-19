import 'dart:async';

import 'package:astrology_app/core/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/utils/logger.dart';
import '../../model/mantra/mantra_history_model.dart';
import '../../services/mantras/download_mantra_service.dart';
import '../../services/mantras/mantra_api_service.dart';

class MantraProvider extends ChangeNotifier {
  Duration currentPosition = Duration.zero, totalDuration = Duration.zero;
  bool isPlaying = true, isComplete = false;
  int currentMantraIndex = 0;
  Timer? _positionUpdateTimer;
  List<MantraHistoryModel>? mantraHistoryList;

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isDownloadLoading = false;
  double downloadProgress = 0.0;
  Future<void> downloadAudio({
    required String url,
    required String title,
    required Function(double) onProgress,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    isDownloadLoading = true;
    notifyListeners();
    await DownloadManager().downloadRemedy(
      url: "${AppConfig.audioBaseurl}$url",
      bhajanId: title,
      title: title,
      onProgress: (progress) {
        downloadProgress = progress;
        notifyListeners();
        onProgress(progress);
      },
      onSuccess: (filePath) {
        downloadProgress = 1.0;
        isDownloadLoading = false;
        notifyListeners();
        onSuccess(filePath);
      },
      onError: (errorMessage) {
        isDownloadLoading = false;
        downloadProgress = 0.0;
        notifyListeners();
        onError(errorMessage);
      },
    );

    isDownloadLoading = false;
    notifyListeners();
  }

  Future<void> downloadMantraText({
    required String fileName,
    required String content,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    isDownloadLoading = true;
    notifyListeners();

    await DownloadManager().downloadTextFile(
      title: fileName,
      content: content,
      onSuccess: onSuccess,
      onError: onError,
    );
    isDownloadLoading = false;
    notifyListeners();
  }

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
        setSongIndex(currentMantraIndex + 1);
        loadAndPlayMusic(mantraHistoryList![currentMantraIndex].audioFile!);
      }
    });
  }

  //
  Future<void> loadAndPlayMusic(String url) async {
    isPlaying = true;
    notifyListeners();
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

  void setSongIndex(int index) {
    currentMantraIndex = index;
    currentPosition = Duration.zero;
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

  Future<void> resetAudioPlayer() async {
    try {
      await _audioPlayer.stop(); // Stops the playback
      await _audioPlayer.seek(Duration.zero); // Resets to the beginning

      currentPosition = Duration.zero;
      isPlaying = false;
      isComplete = false;

      notifyListeners();
    } catch (e) {
      Logger.printError("Audio reset failed: $e");
    }
  }

  //todo --------------------------------> Fetch Mantras from API
  bool isGetMantraHistoryLoading = false;
  Future<void> getMantraHistory() async {
    isGetMantraHistoryLoading = true;
    notifyListeners();
    final result = await MantraApiService.instance.getMantraHistory();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        mantraHistoryList = (r["data"] as List)
            .map((e) => MantraHistoryModel.fromJson(e))
            .toList();
      },
    );
    isGetMantraHistoryLoading = false;
    notifyListeners();
  }
}
