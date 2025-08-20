import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/global_methods.dart';

TextEditingController _txtName = TextEditingController(text: "Priya Sharma");
TextEditingController _txtBirthDate = TextEditingController(text: "31/05/2005");
TextEditingController _txtTimeOfBirth = TextEditingController(text: "10.00 AM");
TextEditingController _txtPlaceOfBirth = TextEditingController(
  text: "United Kingdom",
);
TextEditingController _txtCurrentLocation = TextEditingController(
  text: "United Kingdom",
);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Column(
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
                title: "Full Name",
                controller: _txtName,
              ),
              Row(
                children: [
                  Expanded(
                    child: UnderLinedAppTextField(
                      readOnly: true,
                      title: "Date Of Birth",
                      controller: _txtBirthDate,
                    ),
                  ),
                  Expanded(
                    child: UnderLinedAppTextField(
                      readOnly: true,
                      title: "Time Of Birth",
                      controller: _txtTimeOfBirth,
                    ),
                  ),
                ],
              ),
              UnderLinedAppTextField(
                readOnly: true,
                title: "Place Of Birth",
                controller: _txtPlaceOfBirth,
              ),
              UnderLinedAppTextField(
                readOnly: true,
                title: "Current Location",
                controller: _txtCurrentLocation,
              ),
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
        ],
      ),
    );
  }
}
