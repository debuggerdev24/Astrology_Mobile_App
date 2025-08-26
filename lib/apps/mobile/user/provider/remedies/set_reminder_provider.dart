import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';

class SetReminderProvider extends ChangeNotifier {
  String _selectedFrequency = 'Daily';
  DateTime? _selectedDate;
  List<String>? _selectedWeekDays = [];

  DateTime? get selectedDate => _selectedDate;
  String get selectedFrequency => _selectedFrequency;
  List<String>? get selectedWeekDays => _selectedWeekDays;

  String get formattedDate => _selectedDate != null
      ? DateFormat("dd MMM yyyy").format(_selectedDate!)
      : "";

  void updateFrequency(String value) {
    _selectedFrequency = value;

    // Clear week days if not custom
    if (value != 'Custom' && value != 'custom') {
      _selectedWeekDays?.clear();
    }

    notifyListeners();
  }

  // Method to toggle week day selection
  void toggleWeekDay(String day) {
    _selectedWeekDays ??= [];

    if (_selectedWeekDays!.contains(day)) {
      _selectedWeekDays!.remove(day);
    } else {
      _selectedWeekDays!.add(day);
    }
    notifyListeners();
  }

  Future<void> pickDateTime(BuildContext context) async {
    // Pick Date
    DateTime? pickedDate = await showDatePicker(
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.whiteColor,
              // Purple for selected date
              onPrimary: AppColors.black,
              outline: AppColors.whiteColor,
              surface: AppColors.bgColor,
              // Dark background
              onSurface: AppColors.whiteColor,
              brightness: Brightness.light,
            ),
            // colorScheme: ColorScheme.light(
            //   inversePrimary: AppColors.black,
            //   primary:
            //       AppColors.greyColor, // Purple/indigo for selected date circle
            //   surface: AppColors.whiteColor, // Dark purple/gray background
            //   onSurface: AppColors.black, // White text for dates
            // ),
            // textSelectionTheme: TextSelectionThemeData(
            //   selectionColor: AppColors.white,
            //   selectionHandleColor: AppColors.greyColor,
            // ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // combine Date + Time
    _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

    notifyListeners();
  }
}
