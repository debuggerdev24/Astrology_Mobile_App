import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_config.dart';
import '../../../../../../core/widgets/global_methods.dart';
import '../../../provider/setting/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    context.read<UserProfileProvider>().assignEditorFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    40.h.verticalSpace,
                    topBar(context: context, title: context.translator.profile),
                    32.h.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 22.h,
                      children: [
                        // Full Name Field
                        AppTextField(
                          hintText: translator.enterYourFullName,
                          title: translator.fullName,
                          controller: provider.editNameController,
                          errorMessage: provider.errorNameStr,
                        ),
                        // Date and Time Row
                        Row(
                          spacing: 15.w,
                          children: [
                            // Date of Birth Field
                            Expanded(
                              child: AppTextField(
                                onTap: () => provider.pickBirthDate(
                                  context: context,
                                  isFromEdit: true,
                                ),
                                hintText: "yyyy-mm-dd",
                                readOnly: true,
                                title: translator.dateOfBirth,
                                suffix: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.whiteColor,
                                ),
                                errorMessage: provider.errorTOBStr,
                                controller: provider.editBirthDateController,
                              ),
                            ),

                            // Time of Birth Field
                            Expanded(
                              child: AppTextField(
                                onTap: () => provider.pickBirthTime(
                                  context: context,
                                  isFromEdit: true,
                                ),
                                readOnly: true,
                                suffix: Icon(
                                  Icons.access_time_rounded,
                                  color: AppColors.whiteColor,
                                ),
                                hintText: "Enter your TOB",
                                title: translator.timeOfBirth,
                                errorMessage: provider.errorDOBStr,

                                controller: provider.editBirthTimeController,
                              ),
                            ),
                          ],
                        ),
                        // Place of Birth Field
                        AppTextField(
                          hintText: translator.enterYourBirthPlace,
                          title: translator.placeOfBirth,
                          errorMessage: provider.errorPlaceOfBirthStr,

                          controller: provider.editBirthPlaceController,
                        ),

                        // Current Location Field
                        AppTextField(
                          hintText: translator.enterYourCurrentLocation,
                          errorMessage: provider.errorCurrentLocationStr,

                          title: translator.currentLocation,
                          controller: provider.editCurrentLocationController,
                        ),

                        // Uploaded Palm Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6.h,
                          children: [
                            AppText(
                              text: context.translator.uploadPalm,
                              style: medium(fontSize: 14),
                            ),
                            Row(
                              spacing: 11.w,
                              children: [
                                palmSection(
                                  onTap: () => provider.pickImage(isLeft: true),
                                  palmImage:
                                      (provider.leftHandImageFile == null)
                                      ? AppConfig.imagesBaseurl +
                                            provider.leftHandImageUrl!
                                      : provider.leftHandImageFile,
                                ),
                                palmSection(
                                  onTap: () =>
                                      provider.pickImage(isLeft: false),
                                  palmImage:
                                      (provider.rightHandImageFile == null)
                                      ? AppConfig.imagesBaseurl +
                                            provider.rightHandImageUrl!
                                      : provider.rightHandImageFile,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Save Button
                    AppButton(
                      onTap: () {
                        deBouncer.run(
                          () => provider.updateProfile(
                            context: context,
                            isFromEdit: true,
                          ),
                        );
                      },
                      title: translator.save,
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                    ),
                  ],
                ),
              ),
            ),
            if (provider.isUpdateProfileLoading) FullPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget palmSection({
    required dynamic palmImage, // can be File or String
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.whiteColor),
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child:
              (palmImage is String) // case: URL
              ? CachedNetworkImage(
                  imageUrl: palmImage,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        value: downloadProgress.progress,
                        color: AppColors.whiteColor,
                      ),
                )
              : Image.file(palmImage, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
