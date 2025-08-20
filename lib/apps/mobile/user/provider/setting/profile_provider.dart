import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class ProfileProvider extends ChangeNotifier {
  // Text controllers
  TextEditingController nameController = TextEditingController(
    text: "Priya Sharma",
  );
  TextEditingController placeOfBirthController = TextEditingController(
    text: "United Kingdom",
  );
  TextEditingController currentLocationController = TextEditingController(
    text: "United Kingdom",
  );

  DateTime _birthDate = DateTime.now();
  TimeOfDay _birthTime = TimeOfDay.now();

  DateTime get birthDate => _birthDate;

  TimeOfDay get birthTime => _birthTime;

  // Format date manually without intl (matching your existing format)
  String get formattedBirthDate {
    final day = _birthDate.day.toString().padLeft(2, '0');
    final month = _birthDate.month.toString().padLeft(2, '0');
    final year = _birthDate.year.toString();
    return "$day/$month/$year";
  }

  // Format time manually without intl (matching your existing format)
  String get formattedBirthTime {
    final hour = _birthTime.hourOfPeriod == 0 ? 12 : _birthTime.hourOfPeriod;
    final minute = _birthTime.minute.toString().padLeft(2, '0');
    final period = _birthTime.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
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
              brightness: Brightness.light
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _birthDate = picked;
      notifyListeners();
    }
  }

  Future<void> pickBirthTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      initialTime: _birthTime,
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
                  brightness: Brightness.light
              ),
            ),
            child: child!,
          );
        },
    );

    if (picked != null) {
      _birthTime = picked;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    placeOfBirthController.dispose();
    currentLocationController.dispose();
    super.dispose();
  }
}
