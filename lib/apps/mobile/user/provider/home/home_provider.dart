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
    Future.wait([
    getTodayMantra(),
    getDailyHoroScope(type: AppEnum.daily.name, num: 1),
//gonhaonmpfcipjkaiideeioi.AO-J1Owa4YuB6hV-12rxpJKHrtFSU5Zyip7q_ldC9KjbceZMCsII1K-i2GyvZnbRdDzzgX9tnvt6JZya72Rcy9NlIpNariUDLNCZLXByJRNdyeqTBEaIIlo
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
        return false;
      },
      (r) {
        final data = r["data"];
        moonSign = data["moon_sign"];
        dasha = "${data["dasha_periods"][0]["mahadasha"]} - ${data["dasha_periods"][0]["antardasha"]}";
        isMoonDashaLoading = false;
        notifyListeners();

        return true;
      },
    );

  }

  bool isDailyHoroScopeLoading = true;
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
          Logger.printInfo("Karma Action" + dailyHoroScope!.karmaAction.toString());
        } else if (num == 2) {
          weeklyHoroScope = DailyHoroScopeModel.fromJson(r["data"]);
          // Logger.printInfo("Karma Action" + dailyHoroScope!.karmaAction.toString());
        } else if(num == 3){
          monthlyHoroScope = DailyHoroScopeModel.fromJson(r["data"]);
          // Logger.printInfo("Karma Action" + dailyHoroScope!.karmaAction.toString());
          isDailyHoroScopeLoading = false;
          notifyListeners();
        }
      },
    );
  }

  bool isGetTodayMantraLoading = true;
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
