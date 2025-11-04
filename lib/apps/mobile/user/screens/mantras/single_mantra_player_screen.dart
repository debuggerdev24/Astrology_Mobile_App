import 'package:astrology_app/apps/mobile/user/provider/mantra/mantra_provider.dart';
import 'package:astrology_app/core/constants/app_assets.dart';
import 'package:astrology_app/core/constants/app_colors.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/de_bouncing.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/core/widgets/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/app_button.dart';

class TodayMantraPlayScreen extends StatefulWidget {
  final Map data;

  const TodayMantraPlayScreen({super.key, required this.data});

  @override
  State<TodayMantraPlayScreen> createState() => _TodayMantraPlayScreenState();
}

class _TodayMantraPlayScreenState extends State<TodayMantraPlayScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    context.read<MantraProvider>().setAudioSetting();
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      Logger.printInfo("----------------- Paused App -------------------");

      await context.read<MantraProvider>().resetAudioPlayer();

      context.read<MantraProvider>().disposeAudio();
    } else if (state == AppLifecycleState.resumed) {
      Logger.printInfo("----------------- Resume App -------------------");
      context.read<MantraProvider>().setAudioSetting();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    bool isText = widget.data["isText"];
    bool isFromDetailScreen = widget.data["isFromDetailScreen"] ?? false;
    String mantraName = widget.data["mantraName"];
    String meaning = widget.data["meaning"];
    String textContent = widget.data["textContent"];
    String title = widget.data["title"] ?? "Mantra";
    String url = widget.data["audioFile"] ?? "";
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await context.read<MantraProvider>().resetAudioPlayer();
          context.pop();
        }
      },
      child: AppLayout(
        horizontalPadding: 0,
        body: SingleChildScrollView(
          child: Consumer<MantraProvider>(
            builder: (context, playMantraProvider, child) => Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      40.h.verticalSpace,

                      topBar(
                        context: context,
                        title: title,
                        onLeadingTap: () async {
                          await context
                              .read<MantraProvider>()
                              .resetAudioPlayer();
                          context.pop();
                        },
                      ),
                      60.h.verticalSpace,

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppAssets.omImage),
                          60.h.verticalSpace,
                          //todo --------------------> song details
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AppText(
                                  text: mantraName,
                                  style: medium(fontSize: 22),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Icon(
                                  CupertinoIcons.music_note_2,
                                  color: AppColors.white,
                                  size: 24.sp,
                                ),
                              ),
                            ],
                          ),
                          AppText(
                            text: meaning,
                            style: regular(
                              fontSize: 18,
                              height: 1.2,
                              color: AppColors.greyColor,
                            ),
                          ),
                          28.h.verticalSpace,
                          if (isText)
                            greyColoredBox(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              child: AppText(
                                text: textContent,
                                style: medium(fontSize: 19),
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
                      if (isFromDetailScreen) ...[
                        35.h.verticalSpace,
                        Row(
                          spacing: 10.w,
                          children: [
                            Expanded(
                              child: AppButton(
                                title: context.translator.download,
                                onTap: () async {
                                  deBouncer.run(() {
                                    if (isText) {
                                      playMantraProvider.downloadMantraText(
                                        fileName: mantraName,
                                        content: textContent,
                                        onSuccess: (p0) {
                                          AppToast.success(
                                            context: context,
                                            message: context
                                                .translator
                                                .downloadedSuccessfully,
                                          );
                                        },
                                        onError: (p0) {
                                          AppToast.error(
                                            context: context,
                                            message: "Download Failed.",
                                          );
                                        },
                                      );
                                    } else {
                                      playMantraProvider.downloadAudio(
                                        url: url,
                                        title: mantraName,
                                        onProgress: (progress) {
                                          Logger.printInfo(
                                            'Downloading... ${progress * 100}%',
                                          );
                                        },
                                        onSuccess: (filePath) {
                                          AppToast.success(
                                            context: context,
                                            message: context
                                                .translator
                                                .downloadedSuccessfully,
                                          );
                                          Logger.printInfo(
                                            'Downloaded to: $filePath',
                                          );
                                        },
                                        onError: (errorMessage) {
                                          AppToast.error(
                                            context: context,
                                            message:
                                                'Download failed: $errorMessage',
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                              ),
                            ),

                            Expanded(
                              child: AppButton(
                                onTap: () {
                                  deBouncer.run(() {
                                    SharePlus.instance.share(
                                      ShareParams(
                                        text: "http://138.197.92.15$url",
                                      ),
                                    );
                                  });
                                },
                                title: context.translator.share,
                                buttonColor: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      20.h.verticalSpace,
                    ],
                  ),
                ),
                if (playMantraProvider.isDownloadLoading)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: playMantraProvider.downloadProgress,
                          backgroundColor: AppColors.greyColor.withValues(
                            alpha: 0.3,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        5.h.verticalSpace,
                        AppText(
                          text:
                              "Downloading... ${(playMantraProvider.downloadProgress * 100).toInt()}%",
                          style: regular(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
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
        padding: EdgeInsets.symmetric(horizontal: 10),
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
          style: medium(fontSize: 14),
        ),
        Text(
          playMantraProvider.formatDuration(playMantraProvider.totalDuration),
          style: medium(fontSize: 14),
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
