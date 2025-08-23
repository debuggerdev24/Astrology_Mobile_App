import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/text_style.dart';
import '../utils/error_box.dart';

class AppTextField extends StatelessWidget {
  final String? title, errorMessage;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Widget? prefix, suffix;
  final TextStyle? hintStyle, titleTextStyle;
  final String? hintText, icon;
  final VoidCallback? onSuffixTap, onTap;
  final ValueChanged? onChanged;
  final TextInputType? keyboardType;
  final bool? obscureText, enabled, isMobile, readOnly;
  final EdgeInsets? suffixIconPadding;
  final Color? borderColor, focusBorderColor, prefixIconColor, sufixIconColor;
  final double? borderRadius,
      borderThickness,
      iconSize,
      height,
      textFieldWidth,
      sufixIconSize;
  final EdgeInsets? padding;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;

  final TextStyle? textStyle;

  const AppTextField({
    super.key,
    required this.controller,
    this.errorMessage,
    this.focusNode,
    this.textStyle,
    this.height,
    this.suffixIconPadding,
    this.title,
    this.hintText,
    this.onChanged,
    this.icon,
    this.suffix,
    this.onSuffixTap,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText,
    this.enabled,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
    this.borderThickness,
    this.prefixIconColor,
    this.sufixIconColor,
    this.iconSize,
    this.sufixIconSize,
    this.padding,
    this.textAlign,
    this.hintStyle,
    this.isMobile,
    this.textFieldWidth,
    this.onTap,
    this.prefix,
    this.readOnly,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title ?? "", style: titleTextStyle ?? medium(fontSize: 16)),
        ],
        TextField(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          readOnly: readOnly ?? false,
          onTap: onTap,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: textAlign ?? TextAlign.left,
          inputFormatters: inputFormatters,
          cursorColor: AppColors.secondary,
          style:
              textStyle ?? regular(fontSize: 14, color: AppColors.whiteColor),
          decoration: InputDecoration(
            prefixIcon: prefix,
            suffixIcon: suffix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: AppColors.whiteColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: AppColors.white, width: 1.5),
            ),
            hintText: hintText,
            hintStyle:
                hintStyle ??
                regular(
                  fontSize: 14,
                  color: AppColors.whiteColor.withValues(alpha: 0.7),
                ),
          ),
        ),
        //if (suffixIon != null) ...[
        //                 12.horizontalSpace,
        //                 Padding(
        //                   padding: suffixIconPadding ?? EdgeInsets.all(0),
        //                   child: GestureDetector(
        //                     onTap: onSuffixTap,
        //                     child: SvgPicture.asset(
        //                       suffixIon!,
        //                       height: sufixIconSize?.h ?? 16.h,
        //                       color: sufixIconColor ?? AppColors.whiteColor,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        if (errorMessage?.isNotEmpty ?? false)
          ErrorBox(errorMessage: errorMessage!),
        // Padding(
        //   padding: EdgeInsets.only(top: 0),
        //   child:
        // AppText(
        //   text: errorMessage!,
        //   style: regular(fontSize: 14, color: Colors.red),
        // ),
        // ),
      ],
    );
  }
}

class UnderLinedAppTextField extends StatelessWidget {
  final String? title;
  final String? errorMessage;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final String? hintText;
  final String? icon, suffixIon;
  final VoidCallback? onSuffixTap;
  final ValueChanged? onChanged;
  final TextInputType? keyboardType;
  final bool? obscureText, enabled, readOnly, isMobile;
  final EdgeInsets? suffixIconPadding;
  final Color? borderColor, focusBorderColor, prefixIconColor, sufixIconColor;
  final double? borderRedius,
      borderThickness,
      iconSize,
      height,
      textFieldWidth,
      sufixIconSize;
  final EdgeInsets? padding;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;

  final TextStyle? textStyle;

  const UnderLinedAppTextField({
    super.key,
    required this.controller,
    this.errorMessage,
    this.focusNode,
    this.textStyle,
    this.height,
    this.suffixIconPadding,
    this.title,
    this.hintText,
    this.onChanged,
    this.icon,
    this.suffixIon,
    this.onSuffixTap,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText,
    this.enabled,
    this.borderColor,
    this.focusBorderColor,
    this.borderRedius,
    this.borderThickness,
    this.prefixIconColor,
    this.sufixIconColor,
    this.iconSize,
    this.sufixIconSize,
    this.padding,
    this.textAlign,
    this.hintStyle,
    this.isMobile,
    this.textFieldWidth,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[Text(title ?? "", style: medium(fontSize: 14))],
        TextField(
          readOnly: readOnly ?? false,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: textAlign ?? TextAlign.left,
          inputFormatters: inputFormatters,
          cursorColor: AppColors.secondary,
          style: textStyle ?? medium(fontSize: 16, color: AppColors.whiteColor),
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.whiteColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.whiteColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.whiteColor),
            ),
            hintText: hintText,
            hintStyle: hintStyle ?? regular(fontSize: 14),
          ),
        ),
        //if (suffixIon != null) ...[
        //                 12.horizontalSpace,
        //                 Padding(
        //                   padding: suffixIconPadding ?? EdgeInsets.all(0),
        //                   child: GestureDetector(
        //                     onTap: onSuffixTap,
        //                     child: SvgPicture.asset(
        //                       suffixIon!,
        //                       height: sufixIconSize?.h ?? 16.h,
        //                       color: sufixIconColor ?? AppColors.whiteColor,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        // if (errorMessage?.isNotEmpty ?? false)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 6).r,
        //     child: Text(
        //       errorMessage!,
        //       style: medium(
        //         fontSize: 12,
        //         color: AppColors.red,
        //         fontFamily: AppFontFamily.secondary,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
