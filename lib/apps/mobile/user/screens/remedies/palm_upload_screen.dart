import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../user_dashboard.dart';

class PalmUploadScreen extends StatelessWidget {
  const PalmUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        indexTabUser.value = 0;
        return;
      },
      child: AppLayout(
        body: SingleChildScrollView(
          child: Column(
            children: [
              40.h.verticalSpace,
              topBar(
                showBackButton: false,
                context: context,
                title: context
                    .translator
                    .pleaseUploadYourPalmImageFirst, //"Please upload your palm image first.",
              ),
              42.h.verticalSpace,
              Row(
                spacing: 11.w,
                children: [uploadPalmSection(), uploadPalmSection()],
              ),
              12.h.verticalSpace,
              Row(
                spacing: 11.w,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppText(
                    text: context.translator.leftHand,
                    style: regular(fontSize: 14, color: AppColors.whiteColor),
                  ),
                  AppText(
                    text: context.translator.rightHand,
                    style: regular(fontSize: 14, color: AppColors.whiteColor),
                  ),
                ],
              ),
              50.h.verticalSpace,
              AppText(
                textAlign: TextAlign.center,
                text: context.translator.uploadImageScreenPara,
                // "Your personalized palm reading will only be generated after uploading your palm photo Once the analysis is complete, tailored remedies will be suggested based on your palm and horoscope alignment.",
                style: regular(fontSize: 18),
              ),
              AppButton(
                margin: EdgeInsets.only(bottom: 25.h, top: 50.h),

                onTap: () {
                  context.pushNamed(MobileAppRoutes.palmReadingScreen.name);
                },
                title: context.translator.submitForReading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadPalmSection() {
    return Expanded(
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: AppColors.whiteColor,
          radius: Radius.circular(12.r),
        ),

        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 58.h),

          child: SVGImages(path: AppAssets.uploadImageIcon),
        ),
      ),
    );
  }
}
