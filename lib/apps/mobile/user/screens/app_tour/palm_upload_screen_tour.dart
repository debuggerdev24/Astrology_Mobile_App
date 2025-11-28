import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../provider/remedies/palm_provider.dart';

class PalmUploadScreenTour extends StatelessWidget {
  const PalmUploadScreenTour({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<PalmProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    40.h.verticalSpace,
                    topBar(
                      showBackButton: false,
                      context: context,
                      title: context.translator.pleaseUploadYourPalmImageFirst,
                    ),
                    42.h.verticalSpace,
                    Row(
                      spacing: 11.w,
                      children: [
                        uploadPalmSection(
                          label: "Left Palm",
                          isActive: provider.activePalm == AppEnum.left.name,
                        ),
                        uploadPalmSection(
                          label: "Right Palm",
                          isActive: provider.activePalm == AppEnum.right.name,
                        ),
                      ],
                    ),
                    12.h.verticalSpace,
                    Row(
                      spacing: 11.w,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppText(
                          text: context.translator.leftHand,
                          style: regular(
                            fontSize: 14,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        AppText(
                          text: context.translator.rightHand,
                          style: regular(
                            fontSize: 14,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    50.h.verticalSpace,
                    AppText(
                      textAlign: TextAlign.center,
                      text: context.translator.uploadImageScreenPara,
                      style: regular(fontSize: 18),
                    ),
                    AppButton(
                      margin: EdgeInsets.only(bottom: 25.h, top: 50.h),
                      onTap: () {
                        deBouncer.run(() async {
                          context.pushNamed(
                            MobileAppRoutes.palmReadingScreen.name,
                          );
                          await provider.uploadForReading(context: context);
                        });
                      },
                      title: context.translator.submitForReading,
                    ),
                  ],
                ),
              ),
              // if (provider.isUploading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget uploadPalmSection({
    // required PalmProvider provider,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: Stack(
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: AppColors.whiteColor,
              radius: Radius.circular(12.r),
              dashPattern: [4, 3],
              strokeWidth: 1.5,
            ),
            child: Container(
              height: 158.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: SVGImage(path: AppAssets.uploadImageIcon),
            ),
          ),
        ],
      ),
    );
  }
}
