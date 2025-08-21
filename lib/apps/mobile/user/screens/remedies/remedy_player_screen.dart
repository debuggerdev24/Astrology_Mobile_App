import 'package:astrology_app/core/widgets/app_button.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/svg_image.dart';
import 'package:astrology_app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/text_style.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/global_methods.dart';

class RemedyPlayerScreen extends StatelessWidget {
  final bool isText;
  const RemedyPlayerScreen({super.key, required this.isText});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            40.h.verticalSpace,
            topBar(context: context, title: "Surya Remedy"),
            60.h.verticalSpace,
            SVGImage(path: AppAssets.sunImage),
            60.h.verticalSpace,

            //todo --------------------> song details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Om Surya Naamh",
                      style: medium(fontSize: 22.sp),
                    ),
                    AppText(
                      text: "I bow to Lord Shiva",
                      style: regular(
                        fontSize: 18.sp,
                        height: 1.2,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color: AppColors.white,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            24.h.verticalSpace,
            if (isText)
              greyColoredBox(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18),
                child: AppText(
                  text:
                      "*Namaam‑īśam‑īśāna nirvāṇa‑rūpam Vibhum vyāpakaṃ brahma‑veda‑svarūpam | Nijaṃ nirguṇaṃ nirvikalpaṃ nirīhaṃ Cidākāśam‑ākāśavāsaṃ bhaje’ham ||1||*",
                  style: medium(fontSize: 16.sp),
                ),
              )
            //todo --------------------> slider
            else ...[
              SliderTheme(
                data: const SliderThemeData(trackHeight: 1.6),
                child: Slider(
                  padding: EdgeInsets.zero,
                  min: 0.0,
                  max: 100,
                  activeColor: AppColors.white,
                  inactiveColor: AppColors.greyColor,
                  value: 30,
                  onChanged: (value) {},
                ),
              ),
              2.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("2.05", style: medium(fontSize: 14)),
                  Text("10.05", style: medium(fontSize: 14)),
                ],
              ),

              25.h.verticalSpace,
              //todo --------------------> control
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //todo ------------------> previous
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: AppColors.white,
                      ),
                      iconSize: 45,
                      onPressed: () async {},
                    ),
                    //todo ------------------> play Or pause
                    IconButton(
                      icon: Icon(
                        true
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: AppColors.white,
                      ),
                      iconSize: 75,
                      onPressed: () {},
                    ),

                    //todo ------------------> next
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: AppColors.white,
                      ),
                      iconSize: 45,
                      onPressed: () async {},
                    ),
                  ],
                ),
              ),
            ],
            35.h.verticalSpace,
            Row(
              spacing: 10.w,
              children: [
                Expanded(child: AppButton(title: context.translator.download)),
                Expanded(
                  child: AppButton(
                    title: context.translator.share,
                    buttonColor: AppColors.secondary,
                  ),
                ),
              ],
            ),
            20.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
