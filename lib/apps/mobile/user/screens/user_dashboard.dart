import 'package:astrology_app/apps/mobile/user/screens/consult/consult_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/home/home_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/mantras/daily_mantra_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/palm_upload_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/settings_screen.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/global_methods.dart';
import '../../../../core/widgets/svg_image.dart';

final ValueNotifier<int> indexTabUser = ValueNotifier<int>(0);

List<Widget> pages = [
  HomeScreen(),
  DailyMantraScreen(),
  PalmUploadScreen(),
  ConsultScreen(),
  SettingScreen(),
];

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return ValueListenableBuilder<int>(
      valueListenable: indexTabUser,
      builder: (BuildContext context, int index, Widget? child) {
        return Scaffold(
          body: ValueListenableBuilder(
            valueListenable: isOffline,
            builder: (context, connection, child) {
              if (connection) {
                return pages[index];
              }
              showToast("No Internet Connection!", 5);
              return Center(child: myIndicator());
            },
          ),
          //
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
                  myBottomBrItem(AppAssets.homeIcon, translator.home, 0),
                  myBottomBrItem(AppAssets.mantrasIcon, translator.mantras, 1),
                  myBottomBrItem(
                    AppAssets.remediesIcon,
                    translator.remedies,
                    2,
                  ),
                  myBottomBrItem(AppAssets.consultIcon, translator.consult, 3),
                  myBottomBrItem(
                    AppAssets.settingsIcon,
                    translator.settings,
                    4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget myBottomBrItem(String iconPath, String title, int index) {
    bool isCurrent = index == indexTabUser.value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          indexTabUser.value = index;
        },
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
              bottomLeft: Radius.circular(index == 0 ? 0.r : 10.r),
              bottomRight: Radius.circular(index == 4 ? 0.r : 10.r),
            ),
            color: isCurrent ? Color(0xff575778) : Colors.transparent,
          ),
          duration: Duration(milliseconds: 300),
          child: Center(
            child: Column(
              spacing: 4.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SVGImages(
                  color: isCurrent ? AppColors.white : AppColors.darkBlue,
                  width: 21.w,
                  path: iconPath,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: title,
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                        style: regular(
                          color: isCurrent ? Colors.white : AppColors.darkBlue,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
