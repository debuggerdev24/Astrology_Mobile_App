import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/subscription/current_plan_screen.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_image.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../model/mantra/mantra_history_model.dart';
import '../user_dashboard.dart';

class DailyMantraScreen extends StatelessWidget {
  const DailyMantraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        indexTabUser.value = 0;
        return;
      },
      child: AppLayout(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            16.h.verticalSpace,
            AppText(
              text: context.translator.dailyMantraLog,
              style: bold(
                fontFamily: AppFonts.secondary,
                height: 1.1,
                fontSize: 28.sp,
              ),
            ),
            8.h.verticalSpace,
            Expanded(
              child: Consumer<MantraProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.mantraHistoryList!.length,
                    itemBuilder: (context, index) {
                      final mantra = provider.mantraHistoryList![index];

                      return mantraPlayer(
                        index: index,
                        context: context,
                        mantra: mantra,
                        provider: provider,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mantraPlayer({
    required BuildContext context,
    required MantraHistoryModel mantra,
    required MantraProvider provider,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
            children: [
              SVGImage(path: AppAssets.omIcon, height: 20.5.w),

              12.w.horizontalSpace,
              AppText(
                text: mantra.name,
                style: regular(fontSize: 18, color: AppColors.black),
              ),
              Spacer(),
              AppText(
                text: formatDate(
                  DateTime.parse(mantra.scheduledDate),
                ), //"6 Aug 2025",
                style: regular(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppText(
                  text: "Meaning : ${mantra.meaning}",
                  style: regular(fontSize: 18, color: Colors.grey),
                ),
              ),
              //todo --------------------> text Content
              GestureDetector(
                onTap: () {
                  provider.resetAudioPlayer();
                  provider.setSongIndex(index);
                  context.pushNamed(
                    MobileAppRoutes.playMantraScreen.name,
                    extra: {
                      "isText": true,
                      "mantraList": provider.mantraHistoryList,
                    },
                  );
                },
                child: SVGImage(path: AppAssets.tIcon, height: 34.w),
              ),
              //todo --------------------> audio Content
              GestureDetector(
                onTap: () {
                  provider.setSongIndex(index);
                  Future.wait([
                    provider.loadAndPlayMusic(mantra.audioFile),
                    context.pushNamed(
                      MobileAppRoutes.playMantraScreen.name,
                      extra: {
                        "isText": false,
                        "mantraList": provider.mantraHistoryList,
                      },
                    ),
                  ]);
                },
                child: SVGImage(path: AppAssets.playIcon, height: 34.w),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
