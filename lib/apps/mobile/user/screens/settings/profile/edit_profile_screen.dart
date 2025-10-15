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
import 'package:flutter/services.dart';
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
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

                        //todo Uploaded Palm Section (OLD)
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   spacing: 6.h,
                        //   children: [
                        //     AppText(
                        //       text: context.translator.uploadPalm,
                        //       style: medium(fontSize: 14),
                        //     ),
                        //     Row(
                        //       spacing: 11.w,
                        //       children: [
                        //         palmSection(
                        //           onTap: () => provider.pickImage(isLeft: true),
                        //           palmImage:
                        //               (provider.leftHandImageFile == null)
                        //               ? AppConfig.imagesBaseurl +
                        //                     provider.leftHandImageUrl!
                        //               : provider.leftHandImageFile,
                        //         ),
                        //         palmSection(
                        //           onTap: () =>
                        //               provider.pickImage(isLeft: false),
                        //           palmImage:
                        //               (provider.rightHandImageFile == null)
                        //               ? AppConfig.imagesBaseurl +
                        //                     provider.rightHandImageUrl!
                        //               : provider.rightHandImageFile,
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6.h,
                          children: [
                            AppText(
                              text: context.translator.uploadPalm,
                              style: medium(fontSize: 14),
                            ),

                            //todo Active palm indicator info banner
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                  SizedBox(width: 8.w),
                                  AppText(
                                    text: provider.activePalm == 'left'
                                        ? 'Left palm is active'
                                        : 'Right palm is active',
                                    style: medium(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            4.h.verticalSpace,
                            Row(
                              spacing: 11.w,
                              children: [
                                Expanded(
                                  child: palmSection(
                                    palmImage:
                                        (provider.leftHandImageFile == null)
                                        ? AppConfig.imagesBaseurl +
                                              provider.leftHandImageUrl!
                                        : provider.leftHandImageFile,
                                    isActive: provider.activePalm == 'left',
                                    label: 'Left Palm',
                                    onTap: () {
                                      provider.pickImage(isLeft: true);
                                    },
                                    onSetActive: () {
                                      provider.setActivePalm('left');
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: palmSection(
                                    palmImage:
                                        (provider.rightHandImageFile == null)
                                        ? AppConfig.imagesBaseurl +
                                              provider.rightHandImageUrl!
                                        : provider.rightHandImageFile,
                                    isActive: provider.activePalm == 'right',
                                    label: 'Right Palm',
                                    onTap: () {
                                      provider.pickImage(isLeft: false);
                                    },
                                    onSetActive: () {
                                      provider.setActivePalm('right');
                                    },
                                  ),
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

  // Widget palmSection with selection indicator
  Widget palmSection({
    required dynamic palmImage, // can be File or String
    required VoidCallback onTap,
    required VoidCallback onSetActive,
    required String label,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 🌿 Palm Image
          Container(
            height: 130.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.whiteColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: (palmImage is String)
                  ? CachedNetworkImage(
                      imageUrl: palmImage,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                value: downloadProgress.progress,
                                color: AppColors.whiteColor,
                              ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: Colors.red),
                    )
                  : Image.file(palmImage, fit: BoxFit.cover),
            ),
          ),

          // ✅ Checkmark (Active Palm)
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
                    child: Icon(Icons.check, color: Colors.white, size: 18.sp),
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

          // 🏷 Label at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: onSetActive,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h),
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
                  text: label,
                  style: medium(fontSize: 12, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //todo upload palm section (OLD)
  // Widget palmSection({
  //   required dynamic palmImage, // can be File or String
  //   required VoidCallback onTap,
  // }) {
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: Container(
  //         height: 130.h,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: AppColors.whiteColor),
  //           borderRadius: BorderRadius.circular(12.r),
  //         ),
  //         alignment: Alignment.center,
  //         padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
  //         child:
  //             (palmImage is String) // case: URL
  //             ? CachedNetworkImage(
  //                 imageUrl: palmImage,
  //                 fit: BoxFit.cover,
  //                 progressIndicatorBuilder: (context, url, downloadProgress) =>
  //                     CircularProgressIndicator(
  //                       strokeCap: StrokeCap.round,
  //                       value: downloadProgress.progress,
  //                       color: AppColors.whiteColor,
  //                     ),
  //               )
  //             : Image.file(palmImage, fit: BoxFit.cover),
  //       ),
  //     ),
  //   );
  // }
}
