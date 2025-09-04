import 'package:astrology_app/core/utils/custom_loader.dart';
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
import '../../provider/remedies/palm_provider.dart';
import '../../provider/remedies/set_reminder_provider.dart';

// controllers

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    return AppLayout(
      horizontalPadding: 0,
      body: Consumer<SetReminderProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.h.verticalSpace,
                      topBar(context: context, title: translator.setReminder),

                      24.h.verticalSpace,

                      /// Reminder title
                      AppTextField(
                        borderColor: AppColors.whiteColor,
                        controller: provider.textReminderTitle,
                        title: translator.reminderTitle,
                        hintText: translator.reminderTitleHintText,
                        errorMessage: provider.titleError,
                      ),

                      24.h.verticalSpace,
                      primaryColorText(text: "Repeat Frequency"),
                      16.h.verticalSpace,

                      /// Radio options
                      _buildCustomRadioOption(context, translator.daily),
                      12.h.verticalSpace,
                      _buildCustomRadioOption(context, translator.weekly),

                      /// Animated Week Days Section
                      _buildWeekDaysSection(provider),
                      12.h.verticalSpace,

                      _buildCustomRadioOption(context, translator.monthly),
                      12.h.verticalSpace,
                      _buildCustomRadioOption(context, translator.custom),

                      24.h.verticalSpace,
                      primaryColorText(text: translator.selectDateAndTime),
                      8.h.verticalSpace,

                      //todo ------------->  Date & Time input
                      if (provider.selectedFrequency ==
                              context.translator.monthly ||
                          provider.selectedFrequency ==
                              context.translator.custom)
                        //todo ---------------------> date picker
                        AppTextField(
                          title: "Date",
                          readOnly: true,
                          onTap: () async {
                            await provider.pickDate(context);
                            provider.textDate.text = provider.formattedDate;
                          },
                          prefix: Icon(
                            Icons.calendar_month,
                            color: AppColors.whiteColor,
                          ),
                          controller: provider.textDate,
                          hintText: "Select Date",
                          errorMessage: provider.dateError,
                        ),
                      10.h.verticalSpace,
                      AppTextField(
                        title: "Time",
                        readOnly: true,
                        onTap: () async {
                          await provider.pickTime(context: context);
                        },
                        prefix: Icon(
                          Icons.access_time_rounded,
                          color: AppColors.whiteColor,
                        ),
                        controller: provider.textTime,
                        hintText: "Select Time",
                        errorMessage: provider.timeError,
                      ),
                      AppButton(
                        onTap: () {
                          provider.createReminder(
                            remedyId: context
                                .read<PalmProvider>()
                                .remedies!
                                .remedyId
                                .toString(),
                            context: context,
                          );
                        },
                        title: "Save Reminder",
                        margin: EdgeInsets.only(top: 50.h, bottom: 20.h),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isCreateReminderLoading)
                ApiLoadingFullPageIndicator(),
            ],
          );
        },
      ),
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
          provider.selectedFrequency == 'Weekly' ||
              provider.selectedFrequency == context.translator.weekly
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Color(0xffE5E5E5)),
              ),
              margin: EdgeInsets.only(top: 10.h, left: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.w),
              child: Column(
                spacing: 7,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: weekDays.map((day) {
                  String dayShort = day['short']!;
                  bool isSelected = provider.selectedWeekDays == dayShort;

                  return GestureDetector(
                    onTap: () {
                      provider.selectSingleWeekDay(dayShort);
                    },
                    child: Row(
                      spacing: 8.w,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.selectSingleWeekDay(dayShort);
                          },
                          child: Container(
                            width: 19,
                            height: 19,
                            padding: EdgeInsets.all(isSelected ? 2.4 : 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ),

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
    final isCustom = value == 'Weekly' || value == context.translator.weekly;

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
