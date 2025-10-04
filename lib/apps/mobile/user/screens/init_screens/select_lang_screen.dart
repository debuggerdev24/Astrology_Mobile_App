import 'package:astrology_app/apps/mobile/user/services/settings/locale_storage_service.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/auth/auth_provider.dart';
import '../../provider/setting/locale_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.h.verticalSpace,
              topBar(context: context, title: "Select Language"),
              40.verticalSpace,
              AppText(
                text: 'Choose your preferred language',
                style: semiBold(fontSize: 18),
              ),
              30.verticalSpace,
              // English Option
              _LanguageRadioTile(
                title: 'English',
                languageCode: 'en',
                currentLocale: localeProvider.localeCode,
                onTap: () => localeProvider.setLocale('en'),
              ),

              const Divider(height: 1),

              // Hindi Option
              _LanguageRadioTile(
                title: 'हिंदी (Hindi)',
                languageCode: 'hi',
                currentLocale: localeProvider.localeCode,
                onTap: () => localeProvider.setLocale('hi'),
              ),

              const Divider(height: 1),

              // Tamil Option
              _LanguageRadioTile(
                title: 'தமிழ் (Tamil)',
                languageCode: 'ta',
                currentLocale: localeProvider.localeCode,
                onTap: () => localeProvider.setLocale('ta'),
              ),

              const Spacer(),

              // Optional: Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Future.wait([
                      LocaleStoaregService.setIsLanguageSelected(value: true),

                      context.read<UserAuthProvider>().decideFirstScreen(
                        context,
                      ),
                    ]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: AppText(
                    text: "Confirm",
                    style: semiBold(color: AppColors.black),
                  ),
                ),
              ),
              20.verticalSpace,
            ],
          );
        },
      ),
    );
  }
}

class _LanguageRadioTile extends StatelessWidget {
  final String title;
  final String languageCode;
  final String currentLocale;
  final VoidCallback onTap;

  const _LanguageRadioTile({
    required this.title,
    required this.languageCode,
    required this.currentLocale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLocale == languageCode;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Radio<String>(
              value: languageCode,
              groupValue: currentLocale,
              activeColor: AppColors.primary,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFFFFD700);
                }
                return Colors.white.withValues(alpha: 0.5);
              }),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.standard,
              onChanged: (_) => onTap(),
            ),
            12.horizontalSpace,
            Expanded(
              child: AppText(
                text: title,
                style: regular(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
          ],
        ),
      ),
    );
  }
}
