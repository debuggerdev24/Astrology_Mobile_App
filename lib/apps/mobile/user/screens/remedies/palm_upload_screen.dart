import 'dart:io';

import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../routes/mobile_routes/user_routes.dart';
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
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      40.h.verticalSpace,
                      topBar(
                        showBackButton: false,
                        context: context,
                        title:
                            context.translator.pleaseUploadYourPalmImageFirst,
                      ),
                      42.h.verticalSpace,
                      Row(
                        spacing: 11.w,
                        children: [
                          uploadPalmSection(
                            onTap: () {
                              provider.pickImage(isLeft: true);
                            },
                            onSetActive: () {
                              provider.setActivePalm(AppEnum.left.name);
                            },
                            translator: context.translator,
                            fileImage: provider.leftHandImageFile,
                            isActive: provider.activePalm == AppEnum.left.name,
                          ),
                          uploadPalmSection(
                            onTap: () {
                              provider.pickImage();
                            },
                            translator: context.translator,
                            fileImage: provider.rightHandImageFile,
                            isActive: provider.activePalm == AppEnum.right.name,
                            onSetActive: () {
                              provider.setActivePalm(AppEnum.right.name);
                            },
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
                            if (provider.leftHandImageFile == null &&
                                provider.rightHandImageFile == null) {
                              AppToast.error(
                                context: context,
                                message: "Please upload image",
                              );
                              return;
                            }
                            if (provider.leftHandImageFile == null) {
                              AppToast.error(
                                context: context,
                                message: "Please upload left hand image",
                              );
                              return;
                            }
                            if (provider.rightHandImageFile == null) {
                              AppToast.error(
                                context: context,
                                message: "Please upload right hand image",
                              );
                              return;
                            }
                            // context.read<MantraProvider>().downloadMantraText(
                            //   fileName: "test",
                            //   content:
                            //       "klzjcjkhvkjhcvcxvhxcvkjhvxjhvxckhcxkhvhjhj",
                            //   onSuccess: (p0) {
                            //     AppToast.success(
                            //       context: context,
                            //       message: "Downloaded Successfully.",
                            //     );
                            //   },
                            //   onError: (p0) {
                            //     AppToast.error(
                            //       context: context,
                            //       message: "Download Failes.",
                            //     );
                            //   },
                            // );
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
      ),
    );
  }

  Widget uploadPalmSection({
    required VoidCallback onTap,
    required VoidCallback onSetActive,

    required AppLocalizations translator,
    required File? fileImage,
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
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
          if (fileImage != null) ...[
            //todo Checkmark (Active Palm)
            Align(
              alignment: Alignment.topRight,
              child: isActive
                  ? Container(
                      margin: EdgeInsets.only(top: 8, right: 8),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    )
                  : IconButton(
                      onPressed: onSetActive,
                      icon: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                      splashRadius: 18,
                    ),
            ),
            //todo Label at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: onSetActive,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.9)
                        : Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: AppText(
                    text: translator.active,
                    style: medium(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
