import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart' show AppColors;

class ApiLoadingIndicator extends StatelessWidget {
  const ApiLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      alignment: Alignment.center,
      color: AppColors.black.withValues(alpha: 0.4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(5).r,
        ),
        padding: EdgeInsets.all(12).r,
        child: CupertinoActivityIndicator(
          radius: 18.h,
          color: AppColors.bgColor,
        ),
      ),
    );
  }
}
