import 'package:astrology_app/apps/mobile/user/provider/home/home_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/home/play_mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/global_methods.dart';
import '../../model/home/mantra_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 0,
      body: SingleChildScrollView(
        child: Consumer<UserProfileProvider>(
          builder: (context, profileProvider, child) => Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  if (!provider.isMoonDashaLoading &&
                      !provider.isDailyHoroScopeLoading &&
                      !profileProvider.isGetProfileLoading &&
                      !provider.isGetTodayMantraLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        children: [
                          16.h.verticalSpace,
                          userTopBar(
                            context: context,
                            userName: profileProvider.nameController.text,
                          ),
                          16.h.verticalSpace,
                          dashaAndMoonSection(
                            context: context,
                            provider: provider,
                          ),
                          mantraPlayer(
                            context: context,
                            mantra: provider.todayMantra!,
                          ),
                          greyColoredBox(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.only(
                              top: 16.h,
                              left: 16.w,
                              bottom: 16.h,
                              right: 22.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 14.h,
                              children: [
                                IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: "Karma Focus",
                                        style: bold(
                                          height: 0,
                                          fontFamily: AppFonts.secondary,
                                          fontSize: 20,
                                          decorationColor: AppColors.whiteColor,
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
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
                                        text: provider
                                            .dailyHoroScopeData!
                                            .karmaAction, //"Donate something unasked today.",
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
                                        text: provider
                                            .dailyHoroScopeData!
                                            .karmaCaution, //"Avoid signing contracts after 2 PM.",
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
                                IntrinsicWidth(
                                  child: Column(
                                    children: [
                                      AppText(
                                        text: "Dasha/Nakshatra Insights :",
                                        style: bold(
                                          height: 0,
                                          fontFamily: AppFonts.secondary,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Container(
                                        height: 1.1,
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
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
                                        text: provider
                                            .dailyHoroScopeData!
                                            .rulingPlanet,
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
                                        text: provider
                                            .dailyHoroScopeData!
                                            .nakshatra, //"Anuradha",
                                        style: medium(
                                          fontSize: 18.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      MobileAppRoutes
                                          .dashaNakshatraDetailsScreen
                                          .name,
                                      extra: provider.dailyHoroScopeData,
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                      horizontal: 20.w,
                                    ),
                                    child: AppText(
                                      text: context
                                          .translator
                                          .viewDetailedReading,
                                      style: bold(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ApiLoadingIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget dashaAndMoonSection({
    required BuildContext context,
    required HomeProvider provider,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            AppText(
              text: context.translator.dasha,
              style: medium(fontSize: 14.sp),
            ),
            AppText(
              text: " : ${provider.dasha} ",
              style: medium(fontSize: 14.sp),
            ),
          ],
        ),

        SizedBox(
          height: 20,
          child: VerticalDivider(color: AppColors.whiteColor, thickness: 1),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: context.translator.moonSign,
              overflow: TextOverflow.ellipsis,
              style: medium(fontSize: 14.sp),
            ),
            AppText(
              text: " : ${provider.moonSign}",
              style: medium(fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget mantraPlayer({
    required BuildContext context,
    required MantraModel mantra,
  }) {
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
              children: [
                4.verticalSpace,
                AppText(
                  text: context.translator.dailyMantra,
                  style: bold(
                    color: AppColors.greyColor,
                    fontSize: 20.sp,
                    fontFamily: AppFonts.secondary,
                  ),
                ),
                12.h.verticalSpace,
                Row(
                  children: [
                    SVGImage(path: AppAssets.omIcon, height: 24.h),
                    12.w.horizontalSpace,

                    AppText(
                      text: mantra.name,

                      style: regular(fontSize: 17.sp, color: AppColors.black),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Map<String, dynamic> data = {
                          "isText": true,
                          "mantra": mantra,
                        };
                        context.pushNamed(
                          MobileAppRoutes.playMantraScreen.name,
                          extra: data,
                        );
                      },
                      child: SVGImage(path: AppAssets.tIcon, height: 34.w),
                    ),
                    5.w.horizontalSpace,
                    GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> data = {
                          "isText": false,
                          "mantra": mantra,
                        };
                        context.read<PlayMantraProvider>().loadAndPlayMusic(
                          mantra.audioFile,
                        );
                        await context.pushNamed(
                          MobileAppRoutes.playMantraScreen.name,
                          extra: data,
                        );
                      },
                      child: SVGImage(path: AppAssets.playIcon, height: 34.w),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, right: 16.w),
              child: GestureDetector(
                onTap: () {
                  indexTabUser.value = 1;
                },
                child: AppText(
                  text: context.translator.seeAll,
                  style: medium(fontSize: 12.sp, color: AppColors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userTopBar({required BuildContext context, required String userName}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            text: "${context.translator.goodMorning},\n$userName",
            style: bold(
              fontFamily: AppFonts.secondary,
              height: 1.1,
              fontSize: 28.sp,
            ),
          ),
        ),
        Row(
          spacing: 12.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            SVGImage(path: AppAssets.paymentIcon),
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
