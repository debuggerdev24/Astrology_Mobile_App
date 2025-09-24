import 'package:astrology_app/apps/mobile/user/provider/home/home_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/global_methods.dart';
import '../../model/home/mantra_model.dart';
import '../../provider/setting/subscription_provider.dart';
import '../../services/subscription/subscription_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
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
                          GestureDetector(
                            onTap: () {
                              SubscriptionService().initialize(context);
                            },
                            child: todayMantra(provider),
                          ),
                          //todo -----------------------> Karma Focus
                          greyColoredBox(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10.h,
                              children: [
                                IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: translator.karmaFocus,
                                        style: bold(
                                          height: 0,
                                          fontFamily: AppFonts.secondary,
                                          fontSize: 18,
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
                                actionCaution(
                                  title: translator.action,
                                  detail:
                                      provider.dailyHoroScopeData!.karmaAction,
                                ),
                                actionCaution(
                                  title: translator.caution,
                                  detail:
                                      provider.dailyHoroScopeData!.karmaCaution,
                                  titleColor: AppColors.redColor,
                                ),
                              ],
                            ),
                          ),
                          //todo -------------> Dasha Nakshtra
                          dashaNakshtra(translator, context, provider),
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

  Widget dashaNakshtra(
    AppLocalizations translator,
    BuildContext context,
    HomeProvider provider,
  ) {
    return greyColoredBox(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Column(
              children: [
                AppText(
                  text:
                      "${translator.dasha}/${translator.nakshatra} ${!(context.isTamil) ? translator.inSights : ""} :",
                  style: bold(
                    height: 0,
                    fontFamily: AppFonts.secondary,
                    fontSize: 18,
                  ),
                ),
                Container(height: 1.1, color: AppColors.whiteColor),
              ],
            ),
          ),
          10.h.verticalSpace,
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: translator.yourRulingPlanetToday,
                style: medium(fontSize: 16),
              ),
              AppText(text: " : "),
              AppText(
                text: provider.dailyHoroScopeData!.rulingPlanet,
                style: medium(fontSize: 18, color: AppColors.primary),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(text: translator.nakshatra, style: medium(fontSize: 16)),
              AppText(text: " : "),
              Expanded(
                child: AppText(
                  text: provider.dailyHoroScopeData!.nakshatra, //"Anuradha",
                  style: medium(fontSize: 18, color: AppColors.primary),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed(
                MobileAppRoutes.dashaNakshatraDetailsScreen.name,
                extra: provider.dailyHoroScopeData,
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 11.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              child: AppText(
                text: context.translator.viewDetailedReading,
                style: bold(fontSize: 14, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget todayMantra(HomeProvider provider) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final isTier1Subscribed = subscriptionProvider.isTier1Subscribed;
        if (!isTier1Subscribed) {
          return 20.h.verticalSpace;
        }
        if (provider.todayMantra != null) {
          return mantraPlayer(context: context, mantra: provider.todayMantra!);
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: AppText(
              textAlign: TextAlign.center,
              text: context.translator.noMantraToday,
            ),
          );
        }
      },
    );
  }

  Widget actionCaution({
    required String title,
    required String detail,
    Color? titleColor,
  }) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          style: medium(
            fontSize: 18,
            color: titleColor ?? AppColors.greenColor,
          ),
        ),
        AppText(text: ":"),
        Expanded(
          child: AppText(
            text: detail,
            style: regular(height: 1.2, fontSize: 18),
          ),
        ),
      ],
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
              style: medium(fontSize: 14),
            ),
            AppText(text: " : ${provider.dasha} ", style: medium(fontSize: 14)),
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
              style: medium(fontSize: 14),
            ),
            AppText(
              text: " : ${provider.moonSign}",
              style: medium(fontSize: 14),
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
      margin: EdgeInsets.symmetric(vertical: 18.h),
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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.verticalSpace,
                AppText(
                  text: context.translator.dailyMantra,
                  style: bold(
                    color: AppColors.greyColor,
                    fontSize: 20,
                    fontFamily: AppFonts.secondary,
                  ),
                ),
                6.h.verticalSpace,
                Row(
                  children: [
                    SVGImage(path: AppAssets.omIcon, height: 24),
                    12.w.horizontalSpace,

                    AppText(
                      text: mantra.name,

                      style: regular(fontSize: 17, color: AppColors.black),
                    ),
                    Spacer(),
                    //todo ---------------------------------------> text Content
                    GestureDetector(
                      onTap: () {
                        context.read<MantraProvider>().resetAudioPlayer();
                        Map<String, dynamic> data = {
                          "isText": true,
                          "mantraName": mantra.name,
                          "meaning": mantra.meaning,
                          "textContent": mantra.textContent,
                        };
                        context.pushNamed(
                          MobileAppRoutes.singleMantraPlayerScreen.name,
                          extra: data,
                        );
                      },
                      child: SVGImage(path: AppAssets.tIcon, height: 34.w),
                    ),
                    //todo --------------------------------------> audio Content
                    5.w.horizontalSpace,
                    GestureDetector(
                      onTap: () async {
                        Future.wait([
                          context.read<MantraProvider>().loadAndPlayMusic(
                            mantra.audioFile,
                          ),
                          context.pushNamed(
                            MobileAppRoutes.singleMantraPlayerScreen.name,
                            extra: {
                              "isText": false,
                              "mantraName": mantra.name,
                              "meaning": mantra.meaning,
                              "textContent": mantra.textContent,
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
                  style: medium(fontSize: 12, color: AppColors.black),
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
              fontSize: 28,
            ),
          ),
        ),
        Row(
          spacing: 12.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            SVGImage(path: AppAssets.paymentIcon),
            GestureDetector(
              onTap: () {
                context.pushNamed(MobileAppRoutes.profileScreen.name);
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.userImage),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
