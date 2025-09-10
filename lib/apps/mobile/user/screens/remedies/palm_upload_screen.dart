import 'dart:io';

import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/remedies/palm_provider.dart';
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
        horizontalPadding: 0,
        body: Consumer<PalmProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                          children: [
                            uploadPalmSection(
                              onTap: () {
                                provider.pickImage(isLeft: true);
                              },
                              provider: provider,
                              fileImage: provider.leftHandImageFile,
                            ),
                            uploadPalmSection(
                              onTap: () {
                                provider.pickImage();
                              },
                              provider: provider,
                              fileImage: provider.rightHandImageFile,
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
                            deBouncer.run(() {
                              if (provider.leftHandImageFile != null &&
                                  provider.rightHandImageFile != null) {
                                provider.uploadForReading(
                                  onSuccess: () {
                                    context.pushNamed(
                                      MobileAppRoutes.palmReadingScreen.name,
                                    );
                                  },
                                );

                                return;
                              }
                              AppToast.error(
                                context: context,
                                message: "Please upload palm images",
                              );
                            });
                          },
                          title: context.translator.submitForReading,
                        ),
                      ],
                    ),
                  ),
                ),
                if (provider.isUploading) ApiLoadingFullPageIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget uploadPalmSection({
    required VoidCallback onTap,
    required PalmProvider provider,
    required File? fileImage,
  }) {
    return Expanded(
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: AppColors.whiteColor,
          radius: Radius.circular(12.r),
          dashPattern: [4, 3],
          strokeWidth: 1.5,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 158.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: fileImage != null
                ? Image.file(fileImage, fit: BoxFit.contain)
                : SVGImage(path: AppAssets.uploadImageIcon),
          ),
        ),
      ),
    );
  }
}
