import 'package:flutter/material.dart';

import '../../../../../core/utils/logger.dart';
import '../../services/settings/locale_storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  String _localeCode = LocaleStorageService.localeCode;
  String get localeCode => _localeCode;

  void setLocale(String code) {
    if (!['en', 'hi', 'ta'].contains(code)) return;

    if (_localeCode == code) {
      Logger.printInfo("Locale is already '$code'. No UI update needed.");
      return;
    }

    _localeCode = code;
    LocaleStorageService.setLocaleCode(code);
    Logger.printInfo("Locale updated to: $_localeCode");
    notifyListeners();
  }
}
