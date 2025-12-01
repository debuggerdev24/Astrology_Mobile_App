import 'package:astrology_app/apps/mobile/user/provider/setting/profile_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/app_tutorial/app_tour.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/global_methods.dart';
import 'daily_mantra_screen_tour.dart';

class ProfileScreenTour extends StatefulWidget {
  const ProfileScreenTour({super.key});

  @override
  State<ProfileScreenTour> createState() => _ProfileScreenTourState();
}

class _ProfileScreenTourState extends State<ProfileScreenTour> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
    super.initState();
  }

  void _showTutorial() {
    // Check your existing shared prefs here
    // if (!yourSharedPrefs.hasSeenPalmUploadTutorial) {
    AppTourManager.showProfileTutorial(
      context: context,
      onFinish: () {
        // Save to your shared prefs
        // yourSharedPrefs.setPalmUploadTutorialSeen();

        context.pushNamed(MobileAppRoutes.appInfoTour.name);
      },
      onSkip: () {
        onSkip(context: context);

        // Save to your shared prefs
        // yourSharedPrefs.setPalmUploadTutorialSeen();
      },
    );
    // }
  }

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
                key: AppTourKeys.profileKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 22.h,
                children: [
                  UnderLinedAppTextField(
                    readOnly: true,
                    title: translator.fullName,
                    controller: TextEditingController(text: "Priya Sharma"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: UnderLinedAppTextField(
                          readOnly: true,
                          title: translator.dateOfBirth,
                          controller: TextEditingController(text: "31/05/2000"),
                        ),
                      ),
                      Expanded(
                        child: UnderLinedAppTextField(
                          readOnly: true,
                          title: translator.timeOfBirth,
                          controller: TextEditingController(text: "10.00 AM"),
                        ),
                      ),
                    ],
                  ),
                  UnderLinedAppTextField(
                    readOnly: true,
                    title: translator.placeOfBirth,
                    controller: TextEditingController(text: "United Kingdom"),
                  ),
                  UnderLinedAppTextField(
                    readOnly: true,
                    title: translator.currentLocation,
                    controller: TextEditingController(text: "United Kingdom"),
                  ),
                  AppText(
                    text: translator.uploadedPalm,
                    style: medium(fontSize: 14),
                  ),
                ],
              ),
              22.h.verticalSpace,
              Row(
                spacing: 11.w,
                children: [
                  buildPalmSection(palmImage: AppAssets.palm),
                  buildPalmSection(palmImage: AppAssets.palm),
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
        child: Image.asset(palmImage),
      ),
    );
  }
}
