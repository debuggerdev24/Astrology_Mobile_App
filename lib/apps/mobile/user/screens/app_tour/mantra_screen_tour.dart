import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_image.dart';
import '../../provider/setting/subscription_provider.dart';
import '../subscription/current_plan_screen.dart';

class DailyMantraScreenTour extends StatelessWidget {
  const DailyMantraScreenTour({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.h.verticalSpace,
          AppText(
            text: translator.dailyMantraLog,
            textAlign: TextAlign.center,
            style: bold(
              fontFamily: AppFonts.secondary,
              height: 1.1,
              fontSize: 26,
            ),
          ),
          8.h.verticalSpace,
          Expanded(
            child: Consumer<SubscriptionProvider>(
              builder: (context, subscriptionProvider, _) {
                return Consumer<MantraProvider>(
                  builder: (context, mantraProvider, _) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return mantraPlayer(context: context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget mantraPlayer({required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppText(
                  text: "${context.translator.meaning} : I bow to Lord Shiva",
                  style: regular(
                    fontSize: context.isTamil ? 15 : 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              //todo --------------------> text Content
              SVGImage(path: AppAssets.tIcon, height: 34.w),
              //todo --------------------> audio Content
              SVGImage(path: AppAssets.playIcon, height: 34.w),
            ],
          ),
        ],
      ),
    );
  }
}
