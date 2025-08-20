import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/text_style.dart';

class FAQCard extends StatefulWidget {
  final String question;
  final String answer;

  const FAQCard({super.key, required this.question, required this.answer});

  @override
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.question,
                  style: semiBold(fontSize: 16, color: AppColors.white),
                ),
              ),
              12.horizontalSpace,
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 32.h,
                height: 32.h,
                alignment: Alignment.center,
                child: Icon(
                  isExpanded ? Icons.remove : Icons.add_circle_outline_rounded,
                  size: 24.sp,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
        7.verticalSpace,
        AnimatedContainer(
          alignment: Alignment.topLeft,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: AnimatedOpacity(
            opacity: isExpanded ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Text(
              widget.answer,
              style: medium(
                fontSize: 14,
                color: AppColors.whiteColor.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
