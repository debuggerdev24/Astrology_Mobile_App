import 'package:astrology_app/apps/mobile/user/provider/remedies/palm_provider.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../routes/mobile_routes/user_routes.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PalmProvider>().getRemedies();
    });
    super.initState();
  }

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
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 10,
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
                                  style: medium(fontSize: 16),
                                ),
                                10.h.verticalSpace,
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
                                AppButton(
                                  onTap: () {
                                    provider.getRemedyDetails(
                                      remedyId: remedies.remedyId.toString(),
                                    );
                                    context.pushNamed(
                                      MobileAppRoutes.remedyDetailsScreen.name,
                                    );
                                  },
                                  margin: EdgeInsets.only(top: 18),
                                  title: translator.viewDetails,
                                  fontSize: 14.sp,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
                return remedyShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget remedyShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: Colors.grey[400]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            12.h.verticalSpace,
            ...List.generate(
              2,
              (_) => Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Planet label shimmer
                    Container(
                      width: 95.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    12.h.verticalSpace,
                    // Remedy name shimmer
                    Container(
                      width: double.infinity,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    10.h.verticalSpace,
                    // Type row shimmer
                    Container(
                      width: 180.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    8.h.verticalSpace,
                    // Description shimmer (multiple lines)
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    6.h.verticalSpace,
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    6.h.verticalSpace,
                    Container(
                      width: 220.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    16.h.verticalSpace,
                    // Button shimmer
                    Container(
                      width: double.infinity,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topicWithDetails({required String topic, required String details}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        spacing: 4,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.5),

            child: AppText(text: topic, style: regular(fontSize: 16)),
          ),
          AppText(text: ":", style: regular(fontSize: 16)),
          Expanded(
            flex: 3,
            child: AppText(text: details, style: regular(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
