import 'dart:io';

import 'package:astrology_app/core/utils/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;
  DownloadManager._internal();

  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, double> _downloadProgress = {};

  // Download bhajan with progress tracking
  Future<String?> downloadRemedy({
    required String url,
    required String bhajanId,
    required String title,
    required Function(double) onProgress,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    Logger.printInfo(url);
    try {
      // Request storage permission
      if (!await _requestStoragePermission()) {
        onError('Storage permission denied');
        return null;
      }

      // Get download directory
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        onError('Unable to access download directory');
        return null;
      }

      // Create filename with proper extension
      final fileName = '${title.replaceAll(RegExp(r'[^\w\s-]'), '')}.mp3';
      final filePath = '/storage/emulated/0/Download/$fileName';
      Logger.printInfo(directory.path + fileName);

      // Start download
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            _downloadProgress["temp"] = progress;
            // onProgress(progress);
          }
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 10),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      _downloadProgress.remove(bhajanId);
      onSuccess(filePath);
      return filePath;
    } catch (e) {
      _cancelTokens.remove(bhajanId);
      _downloadProgress.remove(bhajanId);

      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          onError('Download cancelled');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          onError('Connection timeout');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          onError('Download timeout');
        } else {
          onError('Network error: ${e.message}');
        }
      } else {
        Logger.printError('Download failed: ${e.toString()}');
        onError('Download failed');
      }
      return null;
    }
  }

  // Cancel download
  void cancelDownload(String bhajanId) {
    final cancelToken = _cancelTokens[bhajanId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('User cancelled');
    }
  }

  // Get download progress
  double getDownloadProgress(String bhajanId) {
    return _downloadProgress[bhajanId] ?? 0.0;
  }

  // Check if bhajan is downloading
  bool isDownloading(String bhajanId) {
    return _cancelTokens.containsKey(bhajanId);
  }

  // Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // For Android 13+ (API 33+), we don't need storage permission for app-specific directories
        return true;
      } else {
        // For older Android versions
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    }
    return true; // iOS doesn't need explicit storage permission for app directories
  }

  Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory;
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final bhajanDir = Directory('${directory.path}/Bhajans');
        if (!await bhajanDir.exists()) {
          await bhajanDir.create(recursive: true);
        }
        return bhajanDir;
      }
    } catch (e) {
      print('Error getting download directory: $e');
      return null;
    }
  }
}
