import 'package:astrology_app/apps/mobile/user/provider/setting/locale_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/app_layout.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        indexTabUser.value = 0;
        return;
      },
      child: AppLayout(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.h.verticalSpace,
            topBar(
              showBackButton: false,
              context: context,
              title: context.translator.settings,
              actionIcon: PopupMenuButton<String>(
                onSelected: (lang) {
                  if (lang == "English") {
                    localeProvider.setLocale("en");
                  } else if (lang == "Hindi") {
                    localeProvider.setLocale("hi");
                  } else if (lang == "Tamil") {
                    localeProvider.setLocale("ta");
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: "English", child: Text("English")),
                  const PopupMenuItem(value: "Hindi", child: Text("हिंदी")),
                  const PopupMenuItem(value: "Tamil", child: Text("தமிழ்")),
                ],
                child: SizedBox(
                  height: 22.h,
                  width: 22.w,
                  child: SVGImages(path: AppAssets.languageIcon),
                ),
              ),
            ),
            32.h.verticalSpace,
            _section(
              title: context.translator.profileScreen,
              onTap: () {
                context.pushNamed(MobileAppRoutes.profileScreen.name);
              },
            ),
            buildDivider(),
            _section(
              title: context.translator.appInfo,
              onTap: () {
                context.pushNamed(MobileAppRoutes.appInfoScreen.name);
              },
            ),
            buildDivider(),
            _section(title: context.translator.notification, onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Divider(color: AppColors.whiteColor.withValues(alpha: 0.6)),
  );

  Widget _section({required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: AppText(
        text: title,
        style: medium(fontSize: 18.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18.sp,
        color: AppColors.white,
      ),
    );
  }
}

//PopupMenuButton(
//                     onSelected: (lang) {
//                       if (lang == "English") {
//                         settingController.changeLanguage("en");
//                         // translator.translate("en", save: true);
//                       } else {
//                         settingController.changeLanguage("es");
//                         // translator.translate("es", save: true);
//                       }
//                     },
//                     child: Text(
//                       // translator.currentLocale!.languageCode == "en"
//                       //     ? "English"
//                       //     : "Español",
//                       settingController.languageCode == "en"
//                           ? "English"
//                           : "Español",
//                       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                     ),
//                     itemBuilder: (ctx) => [
//                       PopupMenuItem(
//                         value: "English",
//                         child: Text(
//                           "English",
//                           style:
//                               Theme.of(context).textTheme.bodyLarge!.copyWith(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: "Spanish",
//                         child: Text(
//                           "Español",
//                           style:
//                               Theme.of(context).textTheme.bodyLarge!.copyWith(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
