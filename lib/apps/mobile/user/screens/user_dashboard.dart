import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:astrology_app/apps/mobile/user/provider/home/home_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/remedies/set_reminder_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/app_info_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/home/home_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/mantras/daily_mantra_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/palm_upload_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/settings_screen.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/svg_image.dart';
import '../services/settings/notification_service.dart';
import '../services/subscription/subscription_service.dart';

final ValueNotifier<int> indexTabUser = ValueNotifier<int>(0);

List<Widget> _pages = [
  HomeScreen(),
  DailyMantraScreen(),
  PalmUploadScreen(),
  // SetReminderScreen(),
  // ConsultScreen(),
  SettingScreen(),
];

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.wait([
        context.read<SubscriptionProvider>().getActiveSubscriptionPlan(
          context: context,
        ),
        context.read<HomeProvider>().initHomeScreen(),
        context.read<UserProfileProvider>().getProfile(context),
        context.read<SubscriptionProvider>().getSubscriptionPlans(),
        context.read<MantraProvider>().getMantraHistory(),
        context.read<SetReminderProvider>().initializeNotifications(
          context: context,
        ),
        context.read<AppInfoProvider>().init(context: context),
        SubscriptionService().initialize(context),
        NotificationService.instance.init(),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    final isTamil = context.isTamil;
    return ValueListenableBuilder<int>(
      valueListenable: indexTabUser,
      builder: (BuildContext context, int index, Widget? child) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: ValueListenableBuilder<bool>(
            valueListenable: isNetworkConnected,
            builder: (context, connection, child) {
              if (connection) {
                return FadeInUp(
                  from: 0,
                  key: ValueKey(indexTabUser.value),
                  child: _pages[index],
                );
              }

              return AppLayout(
                body: Center(
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.wifi_slash,
                        color: AppColors.whiteColor,
                        size: 30,
                      ),
                      AppText(
                        text: "No Internet Connection!",
                        style: regular(fontSize: 20),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: AppColors.whiteColor,
                      //     borderRadius: BorderRadius.circular(5).r,
                      //   ),
                      //   padding: EdgeInsets.all(12).r,
                      //   child: CupertinoActivityIndicator(
                      //     radius: 18.h,
                      //     color: AppColors.bgColor,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 80.h,
              width: 1.sw,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14.r),
                  topLeft: Radius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myBottomBrItem(
                    AppAssets.homeIcon,
                    translator.home,
                    0,
                    isTamil,
                  ),
                  myBottomBrItem(
                    AppAssets.mantrasIcon,
                    translator.mantras,
                    1,
                    isTamil,
                  ),
                  myBottomBrItem(
                    AppAssets.remediesIcon,
                    translator.remedies,
                    2,
                    isTamil,
                  ),
                  // myBottomBrItem(
                  //   AppAssets.consultIcon,
                  //   translator.consult,
                  //   3,
                  //   isTamil,
                  // ),
                  myBottomBrItem(
                    AppAssets.settingsIcon,
                    translator.settings,
                    3,
                    isTamil,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget myBottomBrItem(
    String iconPath,
    String title,
    int index,
    bool isTamil,
  ) {
    bool isCurrent = index == indexTabUser.value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          indexTabUser.value = index;
        },
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
              bottomLeft: Radius.circular(index == 0 ? 0.r : 10.r),
              bottomRight: Radius.circular(index == 3 ? 0.r : 10.r),
            ),
            color: isCurrent
                ? Color(0xff4a4a76)
                : Colors.transparent, //0xff575778
          ),
          duration: Duration(milliseconds: 450),
          child: Column(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              2.h.verticalSpace,
              SVGImage(
                color: isCurrent ? AppColors.white : AppColors.darkBlue,
                width: (index == 3) ? 25.w : 18.w,
                path: iconPath,
              ),
              if (isCurrent)
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: title,
                        textAlign: TextAlign.center,
                        style: !context.isEng && Platform.isIOS
                            ? bold(
                                color: isCurrent
                                    ? Colors.white
                                    : AppColors.darkBlue,
                                fontSize: 12,
                              )
                            : regular(
                                fontWeight: Platform.isIOS
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: isCurrent
                                    ? Colors.white
                                    : AppColors.darkBlue,
                                fontSize: isTamil ? 10 : 14,
                              ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
