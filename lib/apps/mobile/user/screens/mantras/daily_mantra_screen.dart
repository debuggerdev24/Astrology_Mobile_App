import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_image.dart';
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
              text: "Daily Mantra Log",
              style: bold(
                fontFamily: AppFonts.secondary,
                height: 1.1,
                fontSize: 28.sp,
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return mantraPlayer();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mantraPlayer() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.45),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6.h,
          children: [
            Row(
              children: [
                SVGImages(path: AppAssets.omIcon, height: 24.h),
                12.w.horizontalSpace,

                AppText(
                  text: "Om Namah Shivaya",
                  style: regular(fontSize: 17.sp, color: AppColors.black),
                ),
                Spacer(),
                AppText(
                  text: "6 Aug 2025",
                  style: regular(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: "Meaning : I bow to Lord Shiva",
                  style: regular(fontSize: 12.sp, color: Colors.grey),
                ),
                Spacer(),
                SVGImages(path: AppAssets.tIcon, height: 34.w),
                SVGImages(path: AppAssets.playIcon, height: 34.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
