import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/global_methods.dart';
import '../../provider/remedies/set_reminder_provider.dart';

// controllers
TextEditingController _txtReminderTitle = TextEditingController();
TextEditingController _txtDateTime = TextEditingController();

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return Consumer<SetReminderProvider>(
      builder: (context, provider, child) {
        return AppLayout(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.h.verticalSpace,
                topBar(context: context, title: translator.setReminder),
                24.h.verticalSpace,

                /// Reminder title
                AppTextField(
                  borderColor: AppColors.whiteColor,
                  controller: _txtReminderTitle,
                  title: translator.reminderTitle,
                  hintText: translator.reminderTitleHintText,
                ),

                24.h.verticalSpace,
                primaryColorText(text: "Repeat Frequency"),
                16.h.verticalSpace,

                /// Radio options
                _buildCustomRadioOption(context, translator.daily),
                12.h.verticalSpace,
                _buildCustomRadioOption(context, translator.weekly),
                12.h.verticalSpace,
                _buildCustomRadioOption(context, translator.monthly),
                12.h.verticalSpace,
                _buildCustomRadioOption(context, translator.custom),

                /// Animated Week Days Section
                _buildWeekDaysSection(provider),

                24.h.verticalSpace,
                primaryColorText(text: translator.selectDateAndTime),
                20.h.verticalSpace,

                /// Date & Time input
                AppTextField(
                  readOnly: true,
                  onTap: () async {
                    await provider.pickDateTime(context);
                    _txtDateTime.text = provider.formattedDate;
                  },
                  prefix: Icon(
                    Icons.calendar_month,
                    color: AppColors.whiteColor,
                  ),
                  controller: _txtDateTime,
                  hintText: translator.selectDateAndTime,
                ),
                AppButton(
                  title: "Save Reminder",
                  margin: EdgeInsets.only(top: 50.h, bottom: 20.h),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeekDaysSection(SetReminderProvider provider) {
    final weekDays = [
      {'short': 'Mon', 'full': 'Monday'},
      {'short': 'Tue', 'full': 'Tuesday'},
      {'short': 'Wed', 'full': 'Wednesday'},
      {'short': 'Thu', 'full': 'Thursday'},
      {'short': 'Fri', 'full': 'Friday'},
      {'short': 'Sat', 'full': 'Saturday'},
      {'short': 'Sun', 'full': 'Sunday'},
    ];

    return AnimatedSize(
      alignment: Alignment.center,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child:
          provider.selectedFrequency == 'Custom' ||
              provider.selectedFrequency == context.translator.custom
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Color(0xffE5E5E5)),
              ),
              margin: EdgeInsets.only(top: 16.h, left: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.w),
              child: Column(
                spacing: 6.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: weekDays.map((day) {
                  bool isSelected =
                      provider.selectedWeekDays?.contains(day['short']) ??
                      false;
                  return GestureDetector(
                    onTap: () {
                      provider.toggleWeekDay(day['short']!);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(3.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 14.sp,
                                )
                              : null,
                        ),
                        12.w.horizontalSpace,
                        Text(
                          day['full']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget primaryColorText({required String text}) {
    return AppText(
      text: text,
      style: semiBold(fontSize: 18, color: AppColors.primary),
    );
  }

  Widget _buildCustomRadioOption(BuildContext context, String value) {
    final provider = Provider.of<SetReminderProvider>(context);
    final isCustom = value == 'Custom' || value == context.translator.custom;

    return Row(
      spacing: 8.w,
      children: [
        Radio<String>(
          value: value,
          groupValue: provider.selectedFrequency,
          onChanged: (String? newValue) {
            if (newValue != null) {
              provider.updateFrequency(newValue);
            }
          },
          activeColor: const Color(0xFFFFD700),
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFFFD700);
            }
            return Colors.white.withValues(alpha: 0.5);
          }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        GestureDetector(
          onTap: () {
            provider.updateFrequency(value);
          },
          child: Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              10.w.horizontalSpace,
              if (isCustom)
                AnimatedRotation(
                  turns: provider.selectedFrequency == value ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
