import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/utils/logger.dart';
import '../../services/settings/profile_api_service.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isNotificationOn = true;

  bool get isNotificationOn => _isNotificationOn;

  Future<void> checkSystemNotificationPermission() async {
    final status = await Permission.notification.status;
    _isNotificationOn = status.isGranted;
    notifyListeners();
  }

  set isNotificationOn(bool value) {
    _isNotificationOn = value;
    setNotificationStatus();
    notifyListeners();
  }

  int _androidVersion = 10;
  int get androidVersion => _androidVersion;

  Future<void> getAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      // Get Android version number (13, 14, 15, etc.)
      int version = androidInfo.version.sdkInt;

      // Get Android version release name ("13", "14", etc.)
      _androidVersion = int.parse(androidInfo.version.release);
      notifyListeners();

      Logger.printInfo('Android SDK: $version');
      Logger.printInfo('Android Version: $_androidVersion');
    }
  }

  bool isSetNotificationLoading = false;
  Future<void> setNotificationStatus() async {
    isSetNotificationLoading = true;
    notifyListeners();

    String notificationStatusString = "True";

    if (_isNotificationOn) {
      notificationStatusString = "True";
    } else {
      notificationStatusString = "False";
    }

    Map data = {"notification_enabled": notificationStatusString};

    final result = await UserProfileService.instance.setNotificationStatus(
      data: data,
    );

    result.fold((l) {
      Logger.printInfo(l.errorMessage);
    }, (r) {});

    isSetNotificationLoading = false;
    notifyListeners();
  }
}
