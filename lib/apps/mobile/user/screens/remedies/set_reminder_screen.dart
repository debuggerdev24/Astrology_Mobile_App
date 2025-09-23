import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/custom_loader.dart';
import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/app_layout.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/global_methods.dart';
import '../../provider/remedies/set_reminder_provider.dart';
import '../../services/settings/notification_service.dart';

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  @override
  Widget build(BuildContext context) {
    final translator = context.translator;
    List freqList = [
      translator.daily,
      translator.weekly,
      translator.monthly,
      translator.custom,
    ];
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
                      primaryColorText(text: translator.repeatFrequency),
                      16.h.verticalSpace,

                      /// Radio options
                      _buildCustomRadioOption(
                        context: context,
                        value: 1,
                        displayText: translator.daily,
                      ),
                      12.h.verticalSpace,
                      _buildCustomRadioOption(
                        context: context,
                        value: 2,
                        displayText: translator.weekly,
                      ),
                      // Animated Week Days Section
                      _buildWeekDaysSection(
                        provider: provider,
                        translator: translator,
                      ),
                      12.h.verticalSpace,

                      _buildCustomRadioOption(
                        context: context,
                        value: 3,
                        displayText: translator.monthly,
                      ),
                      12.h.verticalSpace,
                      _buildCustomRadioOption(
                        context: context,
                        value: 4,
                        displayText: translator.custom,
                      ),

                      24.h.verticalSpace,
                      primaryColorText(text: translator.selectDateAndTime),
                      16.h.verticalSpace,
                      //todo ------------->  Date & Time input
                      if (provider.selectedFrequency == 3 ||
                          provider.selectedFrequency == 4)
                      //todo ---------------------> date picker
                      ...[
                        AppTextField(
                          title: translator.date,
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
                          hintText: translator.selectDate,
                          errorMessage: provider.dateError,
                        ),
                        10.h.verticalSpace,
                      ],

                      AppTextField(
                        title: translator.time,
                        readOnly: true,
                        onTap: () async {
                          await provider.pickTime(context: context);
                        },
                        prefix: Icon(
                          Icons.access_time_rounded,
                          color: AppColors.whiteColor,
                        ),
                        controller: provider.textTime,
                        hintText: translator.selectTime,
                        errorMessage: provider.timeError,
                      ),
                      AppButton(
                        onTap: () {
                          provider.createReminder(
                            remedyId: "38",
                            // context
                            //     .read<PalmProvider>()
                            //     .remedies!
                            //     .remedyId
                            //     .toString(),
                            context: context,
                            checkDate: provider.selectedFrequency == 3,
                          );
                        },
                        title: translator.saveReminder,
                        margin: EdgeInsets.only(top: 50.h, bottom: 20.h),
                      ),
                      20.h.verticalSpace,
                      // OutlinedButton.icon(
                      //   onPressed: _checkPendingNotifications,
                      //   icon: const Icon(Icons.list),
                      //   label: const Text("Check Pending"),
                      // ),
                      // OutlinedButton.icon(
                      //   onPressed: _cancelAllNotification,
                      //   icon: const Icon(Icons.list),
                      //   label: const Text("Cancel All"),
                      // ),
                    ],
                  ),
                ),
              ),
              if (provider.isCreateReminderLoading) FullPageIndicator(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _checkPendingNotifications() async {
    // if (!_isInitialized) {
    //   _showMessage('Notifications not initialized yet');
    //   return;
    // }

    try {
      final pending = await NotificationService.instance
          .getPendingNotifications();
      AppToast.info(
        context: context,
        message: 'Pending notifications: ${pending.toString()}',
      );

      // Print details to console
      for (var notification in pending) {
        Logger.printInfo('Pending: ${notification.id} - ${notification.title}');
      }
    } catch (e) {
      AppToast.error(
        context: context,
        message: 'Error checking notifications: $e',
      );
    }
  }

  Future<void> _cancelAllNotification() async {
    try {
      final pending = await NotificationService.instance
          .cancelAllNotifications();
      AppToast.info(context: context, message: 'Cancelled');
    } catch (e) {
      AppToast.error(context: context, message: 'Failed to cancel');
    }
  }

  Widget _buildWeekDaysSection({
    required SetReminderProvider provider,
    required AppLocalizations translator,
  }) {
    final weekDays = [
      {'short': 'Mon', 'full': translator.monday, "value": "Monday"},
      {'short': 'Tue', 'full': translator.tuesday, "value": "Tuesday"},
      {'short': 'Wed', 'full': translator.wednesday, "value": "Wednesday"},
      {'short': 'Thu', 'full': translator.thursday, "value": "Thursday"},
      {'short': 'Fri', 'full': translator.friday, "value": "Friday"},
      {'short': 'Sat', 'full': translator.saturday, "value": "Saturday"},
      {'short': 'Sun', 'full': translator.sunday, "value": "Sunday"},
    ];
    return AnimatedSize(
      alignment: Alignment.center,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: provider.selectedFrequency == 2
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
                  String dayShort = day['value']!;
                  bool isSelected = provider.selectedWeekDays == dayShort;
                  return GestureDetector(
                    onTap: () {
                      provider.selectSingleWeekDay(day["value"]!);
                    },
                    child: Row(
                      spacing: 8.w,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.selectSingleWeekDay(day["value"]!);
                          },
                          child: Container(
                            width: 18,
                            height: 18,
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
                            fontSize: 14,
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
      style: semiBold(fontSize: 16, color: AppColors.primary),
    );
  }

  Widget _buildCustomRadioOption({
    required BuildContext context,
    required int value,
    required String displayText,
  }) {
    final provider = Provider.of<SetReminderProvider>(context);
    final isCustom = value == 2;

    return Row(
      spacing: 8.w,
      children: [
        Radio<int>(
          value: value,
          groupValue: provider.selectedFrequency,
          onChanged: (int? newValue) {
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
                displayText,
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
