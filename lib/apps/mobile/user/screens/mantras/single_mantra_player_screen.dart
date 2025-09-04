import 'package:astrology_app/apps/mobile/user/provider/home/home_provider.dart';
import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TodayMantraPlayScreen extends StatefulWidget {
  final Map data;

  const TodayMantraPlayScreen({super.key, required this.data});

  @override
  State<TodayMantraPlayScreen> createState() => _TodayMantraPlayScreenState();
}

class _TodayMantraPlayScreenState extends State<TodayMantraPlayScreen> {
  @override
  void initState() {
    context.read<MantraProvider>().setAudioSetting();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MantraProvider>().disposeAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isText = widget.data["isText"];
    String mantraName = widget.data["mantraName"];
    String meaning = widget.data["meaning"];
    String textContent = widget.data["textContent"];
    String title = widget.data["title"] ?? "Mantra";
    return AppLayout(
      body: SingleChildScrollView(
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) => Column(
            children: [
              40.h.verticalSpace,
              topBar(context: context, title: title),
              60.h.verticalSpace,
              Consumer<MantraProvider>(
                builder: (context, playMantraProvider, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppAssets.omImage),
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
                              text: mantraName,
                              style: medium(fontSize: 22.sp),
                            ),
                            AppText(
                              text: meaning ?? "Meaning",
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
                    28.h.verticalSpace,
                    if (isText)
                      greyColoredBox(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 18,
                        ),
                        child: Expanded(
                          child: AppText(
                            text: textContent,
                            style: medium(fontSize: 19.sp),
                          ),
                        ),
                      )
                    //todo --------------------> slider
                    else ...[
                      mantraSlider(playMantraProvider),
                      //todo -------------------> Seek numbers
                      seekNumbers(playMantraProvider),
                      30.h.verticalSpace,
                      //todo --------------------> control
                      controlButtons(playMantraProvider),
                    ],
                  ],
                ),
              ),

              18.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget controlButtons(MantraProvider playMantraProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //todo ------------------> previous
          // IconButton(
          //   icon: const Icon(
          //     Icons.skip_previous_rounded,
          //     color: AppColors.white,
          //   ),
          //   iconSize: 45.sp,
          //   onPressed: () async {},
          // ),
          //todo ------------------> play Or pause
          IconButton(
            icon: Icon(
              playMantraProvider.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              color: AppColors.white,
            ),
            iconSize: 75.sp,
            onPressed: () {
              playMantraProvider.playPause();
            },
          ),

          //todo ------------------> next
          // IconButton(
          //   icon: const Icon(
          //     Icons.skip_next_rounded,
          //     color: AppColors.white,
          //   ),
          //   iconSize: 45.sp,
          //   onPressed: () async {},
          // ),
        ],
      ),
    );
  }

  SliderTheme mantraSlider(MantraProvider playMantraProvider) {
    return SliderTheme(
      data: const SliderThemeData(trackHeight: 1.6),
      child: Slider(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        min: 0.0,
        max: playMantraProvider.totalDuration.inMilliseconds.toDouble(),
        activeColor: AppColors.white,
        inactiveColor: AppColors.greyColor,
        value: playMantraProvider.currentPosition.inMilliseconds.toDouble(),

        onChanged: (value) {
          playMantraProvider.seek(Duration(milliseconds: value.toInt()));
        },
      ),
    );
  }

  Row seekNumbers(MantraProvider playMantraProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          playMantraProvider.formatDuration(playMantraProvider.currentPosition),
          style: medium(fontSize: 14.sp),
        ),
        Text(
          playMantraProvider.formatDuration(playMantraProvider.totalDuration),
          style: medium(fontSize: 14.sp),
        ),
      ],
    );
  }
}

////todo --------------------> slider
//             SliderTheme(
//               data: const SliderThemeData(
//                 trackHeight: 1.6,
//               ),
//               child: Slider(
//                 min: 0.0,
//                 max: musicProviderTrue.totalDuration.inMilliseconds.toDouble(),
//                 activeColor: homeProviderTrue.isDarkMode ? Colors.tealAccent : Colors.teal,
//                 value: musicProviderTrue.currentPosition.inMilliseconds.toDouble(),
//                 onChanged: (value) {
//                   musicProviderTrue.seek(Duration(milliseconds: value.toInt()));
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 17),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(musicProviderFalse.formatDuration(musicProviderTrue.currentPosition),
//                   style: Theme.of(context).textTheme.labelSmall),
//                   Text(musicProviderFalse.formatDuration(musicProviderTrue.totalDuration),
//                   style: Theme.of(context).textTheme.labelSmall),
//                 ],
//               ),
//             ),
//             //todo --------------------> control
//             Row(
//                 children: [
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
//                 const Spacer(),
//                   //todo ------------------> previous
//                 IconButton(
//                     icon: const Icon(Icons.skip_previous_rounded),
//                     iconSize: 45,
//                     onPressed: () async {
//                       if(musicProviderTrue.currentMusicIndex > 0){
//                         musicProviderFalse
//                           ..setSongIndex(musicProviderTrue.currentMusicIndex - 1)
//                           ..loadAndPlayMusic(song[musicProviderTrue.currentMusicIndex].downloadUrl[4].url)
//                           ..checkSongLikedOrNot(playSongModel);
//                       }
//                     }),
//                 //todo ------------------> play Or pause
//                 IconButton(
//                   icon: Icon(musicProviderTrue.isPlaying
//                       ? Icons.pause_circle_filled
//                       : Icons.play_circle_fill),
//                   iconSize: 75,
//                   onPressed: (){
//                     musicProviderFalse.playPause();//song[musicProviderTrue.currentMusicIndex].downloadUrl[4].url
//                   },
//                 ),
//                IconButton(
//                icon: const Icon(Icons.skip_next_rounded),
//                iconSize: 45,
//                onPressed: () async {
//                if(musicProviderTrue.currentMusicIndex < song.length-1){
//                musicProviderFalse
//                ..setSongIndex(musicProviderTrue.currentMusicIndex + 1)
//                ..loadAndPlayMusic(song[musicProviderTrue.currentMusicIndex].downloadUrl[4].url)
//                ..checkSongLikedOrNot(playSongModel);
//                }
//                }
//                ),
