import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/subscription/current_plan_screen.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
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
import '../../provider/setting/subscription_provider.dart';
import '../user_dashboard.dart';

class DailyMantraScreen extends StatelessWidget {
  const DailyMantraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
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
                      if (!subscriptionProvider.isTier1Subscribed) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.secondary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                size: 64,
                                color: AppColors.secondary,
                              ),
                            ),
                            24.verticalSpace,
                            AppText(
                              text: translator.premiumAccess,
                              style: semiBold(fontSize: 24),
                            ),
                            12.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: AppText(
                                text: translator.premiumMantraHistory,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            32.verticalSpace,
                            ElevatedButton(
                              onPressed: () {
                                context.pushNamed(
                                  MobileAppRoutes.premiumPlanScreen.name,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.w,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                spacing: 8,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: AppColors.black,
                                  ),
                                  AppText(
                                    text: translator.upgradeToTier1,
                                    style: bold(
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      if (mantraProvider.isGetMantraHistoryLoading) {
                        return ApiLoadingIndicator();
                      }

                      final mantraList = mantraProvider.mantraHistoryList;
                      if (mantraList == null || mantraList.isEmpty) {
                        return Center(
                          child: AppText(text: "No mantra history available."),
                        );
                      }

                      return ListView.builder(
                        itemCount: mantraList.length,
                        itemBuilder: (context, index) {
                          final mantra = mantraList[index];
                          return mantraPlayer(
                            index: index,
                            context: context,
                            mantra: mantra,
                            provider: mantraProvider,
                          );
                        },
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
    //
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
                  text: mantra.name,
                  style: regular(fontSize: 18, color: AppColors.black),
                ),
              ),
              AppText(
                text: formatDate(DateTime.parse(mantra.scheduledDate)),
                style: regular(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppText(
                  text: "${context.translator.meaning} : ${mantra.meaning}",
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
