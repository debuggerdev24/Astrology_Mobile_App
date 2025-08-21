import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get translator => AppLocalizations.of(this)!;
  bool get isTamil => read<LocaleProvider>().localeCode == "ta";
}
