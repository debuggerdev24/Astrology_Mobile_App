import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/global_methods.dart';
import '../provider/setting/profile_provider.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return AppLayout(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  40.h.verticalSpace,
                  topBar(
                    context: context,
                    title: context.translator.profile,
                    showBackButton: false,
                  ),
                  32.h.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      AppTextField(
                        hintText: "Enter your Full Name",
                        title: "Full Name",
                        controller: profileProvider.nameController,
                      ),
                      22.h.verticalSpace,
                      // Date and Time Row
                      Row(
                        spacing: 15.w,
                        children: [
                          // Date of Birth Field
                          Expanded(
                            child: AppTextField(
                              onTap: () =>
                                  profileProvider.pickBirthDate(context),
                              readOnly: true,
                              hintText: "Enter your DOB",
                              suffix: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.whiteColor,
                              ),
                              title: "Date Of Birth",
                              controller: TextEditingController(
                                text: profileProvider.formattedBirthDate,
                              ),
                            ),
                          ),

                          // Time of Birth Field
                          Expanded(
                            child: AppTextField(
                              onTap: () =>
                                  profileProvider.pickBirthTime(context),
                              readOnly: true,
                              hintText: "Enter your TOB",
                              suffix: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.whiteColor,
                              ),

                              title: "Time Of Birth",
                              controller: TextEditingController(
                                text: profileProvider.formattedBirthTime,
                              ),
                            ),
                          ),
                        ],
                      ),
                      22.h.verticalSpace,

                      // Place of Birth Field
                      AppTextField(
                        titleTextStyle: bold(fontSize: 16),
                        hintText: "Enter your Birth Place",
                        title: "Place Of Birth",
                        controller: profileProvider.placeOfBirthController,
                      ),
                      22.h.verticalSpace,

                      // Current Location Field
                      AppTextField(
                        titleTextStyle: bold(fontSize: 16),
                        hintText: "Enter your Current Location",
                        title: "Current Location",
                        controller: profileProvider.currentLocationController,
                      ),
                      22.h.verticalSpace,

                      // Uploaded Palm Section
                      AppText(text: "Upload Palm", style: bold(fontSize: 16)),
                      6.h.verticalSpace,
                      Row(
                        spacing: 11.w,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.whiteColor),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 35.h),
                              child: SVGImage(path: AppAssets.uploadImageIcon),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.whiteColor),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 35.h),
                              child: SVGImage(path: AppAssets.uploadImageIcon),
                            ),
                          ),
                        ],
                      ),
                      10.h.verticalSpace,
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
                    ],
                  ),
                  30.h.verticalSpace,
                  AppText(
                    text:
                        "This app offers spiritual guidance and is not a substitute for professional advice. By continuing, you accept the terms of use and privacy policy.",

                    style: regular(fontSize: 16),
                  ),
                  12.h.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 12.w,
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: false ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(3.5.r),
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 1,
                          ),
                        ),
                      ),
                      AppText(
                        text: "I understand and agree.",
                        style: regular(fontSize: 18),
                      ),
                    ],
                  ),
                  // Save Button
                  AppButton(
                    onTap: () {
                      context.pushNamed(
                        MobileAppRoutes.userDashBoardScreen.name,
                      );
                    },
                    title: "Continue",
                    margin: EdgeInsets.symmetric(vertical: 45.h),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
