import 'dart:io';

import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/global_methods.dart';
import '../../../../core/utils/de_bouncing.dart';
import '../provider/setting/profile_provider.dart';
import '../services/settings/locale_storage_service.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  @override
  void initState() {
    context.read<UserProfileProvider>().nameController.text =
        LocaleStoaregService.loggedInUserName;
    context.read<UserProfileProvider>().clearControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger.printInfo(
      "Logged User Name : ${LocaleStoaregService.loggedInUserName}",
    );
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SingleChildScrollView(
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
                            controller: provider.nameController,
                            errorMessage: provider.errorNameStr,
                          ),
                          22.h.verticalSpace,
                          // Date and Time Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15.w,
                            children: [
                              //todo -----------------------> Date of Birth Field
                              Expanded(
                                child: AppTextField(
                                  onTap: () =>
                                      provider.pickBirthDate(context: context),
                                  readOnly: true,
                                  hintText: "Enter your DOB",
                                  suffix: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.whiteColor,
                                  ),
                                  title: "Date Of Birth",
                                  controller: provider.birthDateController,
                                  errorMessage: provider.errorDOBStr,
                                ),
                              ),
                              // Time of Birth Field
                              Expanded(
                                child: AppTextField(
                                  onTap: () =>
                                      provider.pickBirthTime(context: context),
                                  readOnly: true,
                                  hintText: "Enter your TOB",
                                  suffix: Icon(
                                    Icons.access_time_rounded,
                                    color: AppColors.whiteColor,
                                  ),
                                  errorMessage: provider.errorTOBStr,

                                  title: "Time Of Birth",
                                  controller: provider.birthTimeController,
                                ),
                              ),
                            ],
                          ),
                          22.h.verticalSpace,
                          // Place of Birth Field
                          AppTextField(
                            hintText: "Enter your Birth Place",
                            title: "Place Of Birth",
                            controller: provider.birthPlaceController,
                            errorMessage: provider.errorPlaceOfBirthStr,
                          ),
                          22.h.verticalSpace,
                          // Current Location Field
                          AppTextField(
                            hintText: "Enter your Current Location",
                            title: "Current Location",
                            controller: provider.currentLocationController,
                            errorMessage: provider.errorCurrentLocationStr,
                          ),
                          22.h.verticalSpace,

                          // Uploaded Palm Section
                          AppText(
                            text: "Upload Palm",
                            style: medium(fontSize: 16),
                          ),
                          6.h.verticalSpace,
                          Row(
                            spacing: 11.w,
                            children: [
                              // Left Hand
                              handUploadBox(
                                imageFile: provider.leftHandImageFile,
                                label: "Left Hand",
                                onTap: () => provider.pickImage(isLeft: true),
                              ),

                              // Right Hand
                              handUploadBox(
                                imageFile: provider.rightHandImageFile,
                                label: "Right Hand",
                                onTap: () => provider.pickImage(isLeft: false),
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
                      GestureDetector(
                        onTap: () => provider.toggleAgreement(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 12.w,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: 18.w,
                              height: 18.w,
                              decoration: BoxDecoration(
                                color: provider.isAgreementChecked
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(3.5.r),
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                  width: 1,
                                ),
                              ),
                              child: provider.isAgreementChecked
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 14.sp,
                                    )
                                  : null,
                            ),
                            AppText(
                              text: "I understand and agree.",
                              style: regular(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      // Save Button
                      AppButton(
                        onTap: () {
                          deBouncer.run(() {
                            provider.updateProfile(context: context);
                          });
                        },
                        title: "Continue",
                        margin: EdgeInsets.symmetric(vertical: 45.h),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isUpdateProfileLoading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget handUploadBox({
    required File? imageFile,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          spacing: 10.h,
          children: [
            Container(
              height: 130.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.whiteColor),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12.h),

              child: imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover, height: 100.h)
                  : SVGImage(path: AppAssets.uploadImageIcon),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
