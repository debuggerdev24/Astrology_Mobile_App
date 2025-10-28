import 'package:astrology_app/apps/mobile/user/model/home/daily_horo_scope_model.dart';
import 'package:astrology_app/apps/mobile/user/services/home/home_api_service.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enum/app_enums.dart';
import '../../../../../core/utils/logger.dart';
import '../../model/home/mantra_model.dart';

class HomeProvider extends ChangeNotifier {
  String? dasha, moonSign;
  DailyHoroScopeModel? dailyHoroScope, weeklyHoroScope, monthlyHoroScope;
  MantraModel? todayMantra;

  Future<void> initHomeScreen() async {
    Logger.printInfo("initing home screen");
    await getMoonDasha();
    await Future.wait([
      getDailyHoroScope(type: AppEnum.daily.name, num: 1),
      getTodayMantra(),
    ]);
    await getDailyHoroScope(type: AppEnum.weekly.name, num: 2);
    await getDailyHoroScope(type: AppEnum.monthly.name, num: 3);
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
  Future<void> getDailyHoroScope({String? type, int? num}) async {
    isDailyHoroScopeLoading = true;
    notifyListeners();
    final result = await HomeApiService.instance.getDailyHoroScope(
      queryParameter: {"horoscope_type": type},
    );
    result.fold(
      (l) {
        Logger.printError(l.errorMessage);
      },
      (r) {
        if (num == 1) {
          this.dailyHoroScope = DailyHoroScopeModel.fromJson(r["data"]);
        } else if (num == 2) {
          weeklyHoroScope = DailyHoroScopeModel.fromJson(r["data"]);
        } else {
          monthlyHoroScope = DailyHoroScopeModel.fromJson(r["data"]);
        }
      },
    );
    isDailyHoroScopeLoading = false;
    notifyListeners();
  }

  bool isGetTodayMantraLoading = false;
  Future<void> getTodayMantra() async {
    todayMantra = null;
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
      },
    );
    isGetTodayMantraLoading = false;
    notifyListeners();
  }
}
