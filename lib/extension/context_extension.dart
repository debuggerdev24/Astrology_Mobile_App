import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get translator => AppLocalizations.of(this)!;
}
