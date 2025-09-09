import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_config.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/global_methods.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      body: SingleChildScrollView(
        child: Consumer<UserProfileProvider>(
          builder: (context, provider, child) => Column(
            children: [
              40.h.verticalSpace,
              topBar(
                context: context,
                leadingIcon: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.arrow_back, color: AppColors.white),
                ),
                title: context.translator.profile,
                actionIcon: GestureDetector(
                  onTap: () {
                    context.pushNamed(MobileAppRoutes.editProfileScreen.name);
                  },
                  child: SVGImage(path: AppAssets.editIcon),
                ),
              ),
              32.h.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 22.h,
                children: [
                  UnderLinedAppTextField(
                    readOnly: true,
                    title: translator.fullName,
                    controller: provider.nameController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: UnderLinedAppTextField(
                          readOnly: true,
                          title: translator.dateOfBirth,
                          controller: provider.birthDateController,
                        ),
                      ),
                      Expanded(
                        child: UnderLinedAppTextField(
                          readOnly: true,
                          title: translator.timeOfBirth,
                          controller: provider.birthTimeController,
                        ),
                      ),
                    ],
                  ),
                  UnderLinedAppTextField(
                    readOnly: true,
                    title: translator.placeOfBirth,
                    controller: provider.birthPlaceController,
                  ),
                  UnderLinedAppTextField(
                    readOnly: true,
                    title: translator.currentLocation,
                    controller: provider.currentLocationController,
                  ),
                  AppText(
                    text: translator.uploadedPalm,
                    style: medium(fontSize: 14),
                  ),
                  Row(
                    spacing: 11.w,
                    children: [
                      buildPalmSection(
                        palmImage:
                            "${AppConfig.imagesBaseurl}${provider.leftHandImageUrl ?? ""}",
                      ),
                      buildPalmSection(
                        palmImage:
                            "${AppConfig.imagesBaseurl}${provider.rightHandImageUrl ?? ""}",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPalmSection({required String palmImage}) {
    return Expanded(
      child: Container(
        height: 130.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.whiteColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: CachedNetworkImage(
          imageUrl: palmImage,
          fit: BoxFit.cover,

          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              value:
                  downloadProgress.progress, // Shows loading progress (0 to 1)
              color: AppColors.whiteColor,
            ),
          ),
        ),
        // Image.network(
        //   fit: BoxFit.contain,
        //   AppConfig.imagesBaseurl + provider.rightHandImageUrl!,
        // ),
      ),
    );
  }
}
