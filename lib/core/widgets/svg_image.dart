import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final Color? color;
  final VoidCallback? onTap;

  const SVGImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        path,
        height: height,
        width: width,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      ),
    );
  }
}
