import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isNotificationOn = true;

  bool get isNotificationOn => _isNotificationOn;

  set isNotificationOn(bool value) {
    _isNotificationOn = value;
    notifyListeners();
  }
}
