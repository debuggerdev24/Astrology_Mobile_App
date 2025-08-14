import 'package:astrology_app/core/constants/text_style.dart';
import 'package:flutter/cupertino.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;

  const AppText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.textDecoration,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: style != null
          ? style!.copyWith(decoration: textDecoration)
          : regular(),
    );
  }
}
