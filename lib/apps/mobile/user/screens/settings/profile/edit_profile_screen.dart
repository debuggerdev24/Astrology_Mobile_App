import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/app_text_field.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            40.h.verticalSpace,
            topBar(
              context: context,
              title: context.translator.profileScreen,
              actionIcon: SVGImages(path: AppAssets.editIcon),
            ),
            32.h.verticalSpace,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 22.h,
              children: [
                AppTextField(title: "Full Name", controller: _txtName),
                Row(
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: AppTextField(
                        title: "Date Of Birth",
                        controller: _txtBirthDate,
                      ),
                    ),
                    Expanded(
                      child: AppTextField(
                        title: "Time Of Birth",
                        controller: _txtTimeOfBirth,
                      ),
                    ),
                  ],
                ),
                AppTextField(
                  title: "Place Of Birth",
                  controller: _txtPlaceOfBirth,
                ),
                AppTextField(
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
            AppButtonPrimary(
              title: "Save",
              margin: EdgeInsets.symmetric(vertical: 45.h),
            ),
          ],
        ),
      ),
    );
  }
}
