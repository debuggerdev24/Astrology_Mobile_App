import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/logger.dart';
import '../../services/settings/app_info_service.dart';

class AppInfoProvider extends ChangeNotifier {
  List termsAndCondition = [];

  Future<void> getTermsAndCondition() async {
    final result = await AppInfoService.instance.getTermsAndCondition();
    result.fold(
      (l) {
        Logger.printInfo(l.errorMessage);
      },
      (r) {
        termsAndCondition = r["data"]["sections"];
        termsAndCondition.removeLast();
        termsAndCondition.removeLast();
        notifyListeners();
      },
    );
  }
}
