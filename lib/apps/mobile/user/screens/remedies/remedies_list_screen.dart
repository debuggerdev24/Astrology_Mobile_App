import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../routes/mobile_routes/user_routes.dart';

class RemediesScreen extends StatelessWidget {
  const RemediesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: Column(
        children: [
          40.h.verticalSpace,
          topBar(context: context, title: translator.remedies),
          8.h.verticalSpace,
          Expanded(
            child: Consumer<PalmProvider>(
              builder: (context, provider, child) {
                if (!provider.isGetRemediesLoading) {
                  final remedies = provider.remedies;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        8.h.verticalSpace,
                        ...List.generate(1, (index) {
                          return greyColoredBox(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.fromLTRB(
                              12.w,
                              16.h,
                              12.w,

                              16.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text: "${translator.planet} :",
                                  style: bold(
                                    fontSize: 20,
                                    fontFamily: AppFonts.secondary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.tealColor,
                                    color: AppColors.tealColor,
                                  ),
                                ),
                                16.h.verticalSpace,
                                AppText(
                                  text: remedies!
                                      .remedyName, //"SUN REMEDY – Leadership & Confidence",
                                  style: medium(fontSize: 18),
                                ),
                                topicWithDetails(
                                  topic: translator.type,
                                  details: remedies
                                      .remedyType, //"Donation + Chanting",
                                ),
                                topicWithDetails(
                                  topic: translator.description,
                                  details: remedies
                                      .remedyDescription, //"Repeating mantras for specific energies",
                                ),
                                GestureDetector(
                                  onLongPress: () {
                                    showPremiumDialog(
                                      context: context,
                                      title: "Premium Access",
                                      contentBody: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          18.h.verticalSpace,
                                          AppText(
                                            textAlign: TextAlign.center,
                                            text:
                                                "Full access to Dasha-specific remedies is available only with a Premium Plan (Tier 2).",
                                            style: medium(
                                              fontSize: 16,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          8.h.verticalSpace,
                                          AppText(
                                            textAlign: TextAlign.center,
                                            text:
                                                "Unlock personalized guidance and remedies aligned with your current Dasha period for deeper spiritual alignment.",
                                            style: medium(
                                              fontSize: 16,
                                              color: AppColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },

                                  child: AppButton(
                                    onTap: () {
                                      provider.getRemedyDetails(
                                        remedyId: remedies.remedyId.toString(),
                                      );
                                      context.pushNamed(
                                        MobileAppRoutes
                                            .remedyDetailsScreen
                                            .name,
                                      );
                                    },
                                    width:
                                        context
                                                .read<LocaleProvider>()
                                                .localeCode ==
                                            "ta"
                                        ? null
                                        : 150.w,

                                    margin: EdgeInsets.only(top: 18.h),
                                    child: Row(
                                      spacing: 10.w,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          textAlign: TextAlign.center,
                                          text: translator.viewDetails,
                                          style: bold(
                                            fontSize: 15,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SVGImage(
                                          path: AppAssets.lockIcon,
                                          color: AppColors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
                return ApiLoadingIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget topicWithDetails({required String topic, required String details}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          Expanded(
            child: AppText(
              text: topic,
              style: regular(fontSize: 18.sp),
            ),
          ),
          AppText(
            text: ":",
            style: regular(fontSize: 18.sp),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              text: details,
              style: regular(fontSize: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
