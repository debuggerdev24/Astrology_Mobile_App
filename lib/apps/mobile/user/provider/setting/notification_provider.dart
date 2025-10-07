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
