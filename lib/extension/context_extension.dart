import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get translator => AppLocalizations.of(this)!;
  bool get isTamil => read<LocaleProvider>().localeCode == "ta";
  bool get isHindi => read<LocaleProvider>().localeCode == "hi";
  bool get isEng => read<LocaleProvider>().localeCode == "en";
}

extension MediaQueryExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;
}
