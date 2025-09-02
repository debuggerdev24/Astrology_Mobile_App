import 'package:astrology_app/apps/mobile/user/model/home/daily_horo_scope_model.dart';
import 'package:astrology_app/apps/mobile/user/services/home/home_api_service.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/logger.dart';
import '../../model/home/mantra_model.dart';

class HomeProvider extends ChangeNotifier {
  String? dasha, moonSign;
  DailyHoroScopeModel? dailyHoroScopeData;
  MantraModel? todayMantra;

  Future<void> initHomeScreen() async {
    await Future.wait([getMoonDasha(), getDailyHoroScope(), getTodayMantra()]);
  }

  bool isMoonDashaLoading = true;
  Future<void> getMoonDasha() async {
    isMoonDashaLoading = true;
    notifyListeners();
    final result = await HomeApiService.instance.getMoonDasha();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        final data = r["data"];
        moonSign = data["moon_sign"];
        dasha =
            "${data["dasha_periods"][0]["mahadasha"]} - ${data["dasha_periods"][0]["antardasha"]}";
      },
    );
    isMoonDashaLoading = false;
    notifyListeners();
  }

  bool isDailyHoroScopeLoading = false;
  Future<void> getDailyHoroScope() async {
    isDailyHoroScopeLoading = true;
    notifyListeners();
    final result = await HomeApiService.instance.getDailyHoroScope();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        dailyHoroScopeData = DailyHoroScopeModel.fromJson(r["data"]);
      },
    );
    isDailyHoroScopeLoading = false;
    notifyListeners();
  }

  bool isGetTodayMantraLoading = false;
  Future<void> getTodayMantra() async {
    isGetTodayMantraLoading = true;
    notifyListeners();
    final result = await HomeApiService.instance.getTodayMantra();
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        Logger.printInfo(r["data"].toString());
        todayMantra = MantraModel.fromJson(r["data"]);
        isGetTodayMantraLoading = false;
        notifyListeners();
      },
    );
  }
}
