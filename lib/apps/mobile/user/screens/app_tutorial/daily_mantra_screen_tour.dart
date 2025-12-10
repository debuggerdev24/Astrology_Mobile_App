import 'dart:io';

import 'package:astrology_app/apps/mobile/user/screens/app_tutorial/dash_board_tour.dart';
import 'package:astrology_app/apps/mobile/user/services/settings/locale_storage_service.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_image.dart';
import '../subscription/current_plan_screen.dart';
import 'app_tour.dart';

class DailyMantraScreenTour extends StatefulWidget {
  const DailyMantraScreenTour({super.key});

  @override
  State<DailyMantraScreenTour> createState() => _DailyMantraScreenTourState();
}

class _DailyMantraScreenTourState extends State<DailyMantraScreenTour> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
  }

  void _showTutorial() {
    // Check your existing shared prefs here
    // if (!yourSharedPrefs.hasSeenMantraTutorial) {
    AppTourManager.showMantraTutorial(
      context: context,
      onFinish: () {
        indexTabUserTour.value = 2;
      },
      onSkip: () {
        onSkip(context: context);
      },
    );
    // }
  }

  Widget build(BuildContext context) {
    final translator = context.translator;
    return PopScope(
      canPop: false,

      child: AppLayout(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.h.verticalSpace,
            GestureDetector(
              onTap: () {
                _showTutorial();
              },
              child: AppText(
                text: translator.dailyMantraLog,
                textAlign: TextAlign.center,
                style: bold(
                  fontFamily: AppFonts.secondary,
                  height: 1.1,
                  fontSize: 26,
                ),
              ),
            ),
            8.h.verticalSpace,
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => 16.h.verticalSpace,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _mantraPlayer(
                    context: context,
                    isFirstItem: index == 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mantraPlayer({
    required BuildContext context,
    required bool isFirstItem,
  }) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                color: AppColors.white,
                blurRadius: 12,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6.h,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: SVGImage(path: AppAssets.omIcon, height: 20.5.w),
                  ),
                  12.w.horizontalSpace,
                  Expanded(
                    child: AppText(
                      text: "Om Namah Shivay",
                      style: regular(
                        fontSize: context.isTamil ? 15.5 : 18,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  AppText(
                    text: formatDate(DateTime.now()),
                    style: regular(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                // Attach key only to first item
                // key: isFirstItem ? AppTourKeys.mantraMeaningKey : null,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppText(
                      text:
                          "${context.translator.meaning} : I bow to Lord Shiva",
                      style: regular(
                        fontSize: context.isTamil ? 15 : 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Text Content Icon
                  Container(
                    // key: isFirstItem ? AppTourKeys.mantraTextIconKey : null,
                    child: SVGImage(path: AppAssets.tIcon, height: 34.w),
                  ),
                  // Audio Content Icon
                  Container(
                    // key: isFirstItem ? AppTourKeys.mantraAudioIconKey : null,
                    child: SVGImage(path: AppAssets.playIcon, height: 34.w),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(right: Platform.isIOS ? 12.w : 0),

            child: Container(
              key: isFirstItem ? AppTourKeys.mantraPlayerCardKey : null,
            ),
          ),
        ),
      ],
    );
  }
}

void onSkip({required BuildContext context}) {
  LocaleStoaregService.setIsFirstTime(false);
  context.goNamed(MobileAppRoutes.userDashBoardScreen.name, extra: true);
}
