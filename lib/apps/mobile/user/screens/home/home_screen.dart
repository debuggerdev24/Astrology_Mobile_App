import 'package:astrology_app/apps/mobile/user/provider/home/home_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:astrology_app/main.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/global_methods.dart';
import '../../model/home/mantra_model.dart';
import '../../provider/setting/subscription_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    Logger.printInfo(
      "Network Connection" + isNetworkConnected.value.toString(),
    );
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<UserProfileProvider>(
        builder: (context, profileProvider, child) => Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return (!provider.isMoonDashaLoading &&
                    !provider.isDailyHoroScopeLoading &&
                    !profileProvider.isGetProfileLoading &&
                    !provider.isGetTodayMantraLoading)
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        16.h.verticalSpace,
                        userTopBar(
                          context: context,
                          userName: profileProvider.nameController.text,
                        ),
                        12.h.verticalSpace,
                        dashaAndMoonSection(
                          context: context,
                          provider: provider,
                        ),
                        todayMantra(provider),
                        horoscopeTabSection(provider, translator, context),
                        //   greyColoredBox(
                        //                             margin: EdgeInsets.only(bottom: 20.h),
                        //                             padding: EdgeInsets.symmetric(
                        //                               horizontal: 10,
                        //                               vertical: 10, //
                        //                             ),
                        //                             child: Column(
                        //                               crossAxisAlignment: CrossAxisAlignment.start,
                        //                               spacing: 10.h,
                        //                               children: [
                        //                                 IntrinsicWidth(
                        //                                   child: Column(
                        //                                     crossAxisAlignment:
                        //                                         CrossAxisAlignment.start,
                        //                                     children: [
                        //                                       AppText(
                        //                                         text: translator.karmaFocus,
                        //                                         style: bold(
                        //                                           height: 0,
                        //                                           fontFamily: AppFonts.secondary,
                        //                                           fontSize: 18,
                        //                                           decorationColor: AppColors.whiteColor,
                        //                                         ),
                        //                                       ),
                        //                                       Container(
                        //                                         height: 1,
                        //                                         color: AppColors.whiteColor,
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //
                        //                                 actionCaution(
                        //                                   title: translator.action,
                        //                                   context: context,
                        //                                   detail: provider.dailyHoroScope!.karmaAction,
                        //                                 ),
                        //                                 actionCaution(
                        //                                   context: context,
                        //                                   title: translator.caution,
                        //                                   detail: provider.dailyHoroScope!.karmaCaution,
                        //                                   titleColor: AppColors.redColor,
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           //todo -------------> Dasha Nakshtra
                        //                           dashaNakshtra(
                        //                             translator,
                        //                             context,
                        //                             provider.dailyHoroScope,
                        //                           ),
                      ],
                    ),
                  )
                : _homeShimmer();
          },
        ),
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
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: AppText(
              textAlign: TextAlign.center,
              style: medium(fontSize: context.isTamil ? 17.5 : 20),

              text: context.translator.noMantraToday,
            ),
          );
        }
      },
    );
  }

  Widget dashaNakshtra(
    AppLocalizations translator,
    BuildContext context,
    dynamic horoscopeData,
  ) {
    return greyColoredBox(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Column(
              children: [
                AppText(
                  text:
                      "${translator.dasha}/${translator.nakshatra} ${!(context.isTamil) ? translator.inSights : ""}:",
                  style: bold(
                    height: 0,
                    fontFamily: AppFonts.secondary,
                    fontSize: context.isTamil ? 16 : 18,
                  ),
                ),
                Container(height: 1.1, color: AppColors.whiteColor),
              ],
            ),
          ),
          5.h.verticalSpace,
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: AppText(
                  text: translator.yourRulingPlanetToday,

                  style: medium(fontSize: context.isTamil ? 16 : 18),
                ),
              ),

              AppText(text: " : "),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: AppText(
                  text: horoscopeData!.rulingPlanet,
                  style: medium(
                    fontSize: context.isTamil ? 16 : 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: AppText(
                  text: translator.nakshatra,
                  style: medium(fontSize: context.isTamil ? 16 : 18),
                ),
              ),
              AppText(text: " : "),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: AppText(
                    text: horoscopeData!.nakshatra, //"Anuradha",
                    style: medium(
                      fontSize: context.isTamil ? 16 : 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed(
                MobileAppRoutes.dashaNakshatraDetailsScreen.name,
                extra: horoscopeData,
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
                style: bold(
                  fontSize: context.isTamil ? 13 : 14,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionCaution({
    required String title,
    required String detail,
    required BuildContext context,
    Color? titleColor,
  }) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: AppText(
            text: title,
            style: medium(
              fontSize: context.isTamil ? 16 : 18,
              color: titleColor ?? AppColors.greenColor,
            ),
          ),
        ),
        AppText(text: ":"),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: AppText(
              text: detail,
              style: regular(height: 1.2, fontSize: context.isTamil ? 16 : 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget dashaAndMoonSection({
    required BuildContext context,
    required HomeProvider provider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: context.translator.dasha,
              style: regular(fontSize: context.isTamil ? 15 : 17),
            ),
            AppText(
              text: " : ${provider.dasha} ",
              style: regular(fontSize: context.isTamil ? 15 : 17),
            ),
          ],
        ),
        4.verticalSpace,
        // SizedBox(
        //   height: 20,
        //   child: VerticalDivider(color: AppColors.whiteColor, thickness: 1),
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: context.translator.moonSign,
              overflow: TextOverflow.ellipsis,
              style: regular(fontSize: context.isTamil ? 15 : 17),
            ),
            AppText(
              text: " : ${provider.moonSign}",
              style: regular(fontSize: context.isTamil ? 15 : 17),
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
      margin: EdgeInsets.only(top: 14.h, bottom: 18.h),
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
                    fontSize: context.isTamil ? 18 : 20,
                    fontFamily: AppFonts.secondary,
                  ),
                ),
                6.h.verticalSpace,
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: SVGImage(path: AppAssets.omIcon, height: 24),
                    ),
                    8.w.horizontalSpace,

                    Expanded(
                      child: AppText(
                        text: mantra.name,
                        overflow: TextOverflow.ellipsis,
                        style: regular(
                          fontSize: context.isTamil ? 16 : 18,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    if (mantra.textContent != null)
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
                    if (mantra.audioFile != null)
                      GestureDetector(
                        onTap: () async {
                          Future.wait([
                            context.read<MantraProvider>().loadAndPlayMusic(
                              mantra.audioFile!,
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
            text:
                "${decideGreetingByTime(translator: context.translator)},\n$userName",
            style: bold(
              fontFamily: AppFonts.secondary,
              height: 1.1,
              fontSize: context.isTamil ? 25 : 28,
            ),
          ),
        ),
        2.w.horizontalSpace,
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
        // Row(
        //   spacing: 12.w,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     SVGImage(path: AppAssets.paymentIcon),
        //   ],
        // ),
      ],
    );
  }

  String decideGreetingByTime({required AppLocalizations translator}) {
    Logger.printInfo(DateTime.now().hour.toString());
    final currentHour = DateTime.now().hour;
    if (currentHour < 11) {
      return "${translator.goodMorning}";
    } else if (currentHour < 17) {
      return "${translator.goodAfternoon}";
    } else {
      return "${translator.goodEvening}";
    }
  }

  Widget horoscopeTabSection(
    HomeProvider provider,
    AppLocalizations translator,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //todo ------------->  Custom Tab Bar
          Container(
            margin: EdgeInsets.only(bottom: 8.w),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TabBar(
              padding: EdgeInsets.only(right: context.isTamil ? 10 : 0),
              controller: _tabController,
              labelPadding: EdgeInsets.zero,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,

              labelStyle: bold(
                fontSize: context.isTamil ? 12.5 : 16,
                color: AppColors.whiteColor,
              ),
              unselectedLabelStyle: medium(
                fontSize: context.isTamil ? 11 : 14,

                color: AppColors.whiteColor.withValues(alpha: 0.57),
              ),

              tabs: [
                tab(title: translator.daily, icon: Icons.today),
                tab(title: translator.weekly, icon: Icons.view_week),
                tab(title: translator.monthly, icon: Icons.calendar_month),
              ],
            ),
          ),

          // Tab View Content
          Container(
            height: 500.h,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Daily Tab
                _buildHoroscopeContent(
                  provider.dailyHoroScope,
                  translator,
                  context,
                ),
                // Weekly Tab
                _buildHoroscopeContent(
                  provider.weeklyHoroScope,
                  translator,
                  context,
                ),
                // Monthly Tab
                _buildHoroscopeContent(
                  provider.monthlyHoroScope,
                  translator,
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tab({required String title, required var icon}) {
    return Tab(
      child: Row(
        spacing: 6.w,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.sp),
          Text(title, style: TextStyle(fontFamily: AppFonts.primary)),
        ],
      ),
    );
  }

  // Add this helper method to build content for each tab:
  Widget _buildHoroscopeContent(
    dynamic horoscopeData,
    AppLocalizations translator,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4),
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Karma Focus Section
          greyColoredBox(
            margin: EdgeInsets.only(bottom: 18.h),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.h,
              children: [
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Container(height: 1, color: AppColors.whiteColor),
                    ],
                  ),
                ),
                actionCaution(
                  title: translator.action,
                  context: context,
                  detail: horoscopeData.karmaAction,
                ),
                actionCaution(
                  context: context,
                  title: translator.caution,
                  detail: horoscopeData.karmaCaution,
                  titleColor: AppColors.redColor,
                ),
              ],
            ),
          ),
          // Dasha Nakshatra Section
          dashaNakshtra(translator, context, horoscopeData),
        ],
      ),
    );
  }
}

Widget _homeShimmer() {
  return Shimmer.fromColors(
    baseColor: AppColors.greyColor,
    highlightColor: Colors.grey[400]!,
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.h.verticalSpace,
            // ---------------- Top Bar Placeholder ----------------
            Row(
              children: [
                Container(
                  width: 200.w,
                  height: 28.h,

                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Spacer(),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            16.h.verticalSpace,

            // ---------------- Dasha & Moon Section ----------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.greyColor,
                  ),
                ),
                6.h.verticalSpace,
                Container(
                  width: 100.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.greyColor,
                  ),
                ),
                4.h.verticalSpace,
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
            16.h.verticalSpace,
            // ---------------- Today Mantra Card ----------------
            Container(
              width: double.infinity,
              height: 110.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            16.h.verticalSpace,

            // ---------------- Karma Focus Box ----------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.h),
                    child: Container(
                      width: double.infinity,
                      height: 20.h,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            ),
            16.h.verticalSpace,

            // ---------------- Dasha Nakshatra Box ----------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.h),
                    child: Container(
                      width: double.infinity,
                      height: 20.h,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            ),
            20.h.verticalSpace,
          ],
        ),
      ),
    ),
  );
}
