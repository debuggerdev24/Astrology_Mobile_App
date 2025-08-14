import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            16.h.verticalSpace,
            userTopBar(),
            16.h.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Dasha : Venus-Mars",
                  style: bold(fontSize: 14.sp),
                ),
                Container(height: 20, width: 1, color: AppColors.whiteColor),
                AppText(
                  text: "Moon Sign : Virgo",
                  style: bold(fontSize: 14.sp),
                ),
              ],
            ),
            mantraPlayer(),
            Container(
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.only(
                top: 16.h,
                left: 16.w,
                bottom: 16.h,
                right: 22.w,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.whiteColor),
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.greyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14.h,
                children: [
                  AppText(
                    text: "Karma Focus",
                    style: bold(
                      fontFamily: AppFonts.secondary,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.whiteColor,
                    ),
                  ),
                  Row(
                    spacing: 8.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Action",
                        style: medium(
                          fontSize: 18.sp,
                          color: AppColors.greenColor,
                        ),
                      ),
                      AppText(text: "  :"),
                      Expanded(
                        child: AppText(
                          text: "Donate something unasked today.",
                          style: regular(fontSize: 18.sp),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Caution",
                        style: medium(
                          fontSize: 18.sp,
                          color: AppColors.redColor,
                        ),
                      ),
                      AppText(text: ":"),
                      Expanded(
                        child: AppText(
                          text: "Avoid signing contracts after 2 PM.",
                          style: regular(fontSize: 18.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //todo -------------> Dasha Nakshtra
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                top: 16.h,
                left: 16.w,
                bottom: 16.h,
                right: 22.w,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.whiteColor),
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.greyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14.h,
                children: [
                  AppText(
                    text: "Dasha/Nakshatra Insights :",
                    style: bold(
                      fontFamily: AppFonts.secondary,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.whiteColor,
                    ),
                  ),
                  Row(
                    spacing: 10.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Your ruling planet today",
                        style: medium(fontSize: 16.sp),
                      ),
                      AppText(text: ":"),
                      Expanded(
                        child: AppText(
                          text: "Jupiter",
                          style: medium(
                            fontSize: 18.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Nakshatra",
                        style: medium(fontSize: 16.sp),
                      ),
                      AppText(text: ":"),
                      Expanded(
                        child: AppText(
                          text: "Anuradha",
                          style: medium(
                            fontSize: 18.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.h),
                    decoration: BoxDecoration(color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r)
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 20.w,
                    ),
                    child: AppText(
                      text: "View Detailed Reading",
                      style: bold(fontSize: 14.sp, color: AppColors.black,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mantraPlayer() {
    return Container(
      margin: EdgeInsets.only(top: 18.h, bottom: 20.h),
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
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.h,
              children: [
                AppText(
                  text: "Daily Mantra",
                  style: bold(
                    color: Colors.grey,
                    fontSize: 20.sp,
                    fontFamily: AppFonts.secondary,
                  ),
                ),
                Row(
                  children: [
                    SVGImages(path: AppAssets.omIcon, height: 24.h),
                    12.w.horizontalSpace,

                    AppText(
                      text: "Om Namah Shivaya",
                      style: regular(fontSize: 17.sp, color: AppColors.black),
                    ),
                    Spacer(),
                    SVGImages(path: AppAssets.tIcon, height: 34.w),
                    SVGImages(path: AppAssets.playIcon, height: 34.w),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, right: 16.w),
              child: AppText(
                text: "See All",
                style: medium(fontSize: 12.sp, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: "Good Morning,\nPriya",
          style: bold(
            fontFamily: AppFonts.secondary,
            height: 1.1,
            fontSize: 28.sp,
          ),
        ),
        Row(
          spacing: 12.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            SVGImages(path: AppAssets.paymentIcon),
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                // image: DecorationImage(
                //     image:
                // AssetImage()
                // ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
