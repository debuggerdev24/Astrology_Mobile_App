import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/global_methods.dart';
import '../../../provider/setting/profile_provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
                    actionIcon: SVGImage(path: AppAssets.editIcon),
                  ),
                  32.h.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 22.h,
                    children: [
                      // Full Name Field
                      AppTextField(
                        hintText: "Enter your Full Name",

                        title: "Full Name",
                        controller: profileProvider.nameController,
                      ),

                      // Date and Time Row
                      Row(
                        spacing: 15.w,
                        children: [
                          // Date of Birth Field
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  profileProvider.pickBirthDate(context),
                              child: AppTextField(
                                hintText: "Enter your DOB",

                                title: "Date Of Birth",
                                controller: TextEditingController(
                                  text: profileProvider.formattedBirthDate,
                                ),
                              ),
                            ),
                          ),

                          // Time of Birth Field
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  profileProvider.pickBirthTime(context),
                              child: AppTextField(
                                hintText: "Enter your TOB",

                                title: "Time Of Birth",
                                controller: TextEditingController(
                                  text: profileProvider.formattedBirthTime,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Place of Birth Field
                      AppTextField(
                        hintText: "Enter your Birth Place",

                        title: "Place Of Birth",
                        controller: profileProvider.placeOfBirthController,
                      ),

                      // Current Location Field
                      AppTextField(
                        hintText: "Enter your Current Location",

                        title: "Current Location",
                        controller: profileProvider.currentLocationController,
                      ),

                      // Uploaded Palm Section
                      AppText(
                        text: "Uploaded Palm",
                        style: medium(fontSize: 14.sp),
                      ),
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
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Image.asset(AppAssets.palm1),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.whiteColor),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Image.asset(AppAssets.palm2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Save Button
                  AppButton(
                    title: "Save",
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
