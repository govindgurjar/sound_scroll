import 'package:sound_scrolls/model/podcast_model.dart';
import 'package:flutter/material.dart';

import '../../../../provider/audio_player_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class PodcastPlayer extends StatefulWidget {
  const PodcastPlayer({
    Key? key,
    required this.activeIndex,
    required this.activePodCast,
  }) : super(key: key);

  final int activeIndex;
  final PodCast activePodCast;

  @override
  State<PodcastPlayer> createState() => _PodcastPlayerState();
}

class _PodcastPlayerState extends State<PodcastPlayer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioPlayerProvider>(context);
    return AnimatedContainer(
      // height: 200,
      constraints: const BoxConstraints(),
      width: MediaQuery.of(context).size.width - 24,
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple.shade400,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: SizedBox(
                    width: 55,
                    height: 56,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        widget.activePodCast.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.activePodCast.episodes[widget.activeIndex].title,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.activePodCast.name,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    iconSize: 30,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      audioProvider.playPreviewsFormEpisodeList();
                    },
                    icon: const Icon(Icons.arrow_circle_left_rounded),
                  ),
                  audioProvider.isLoadingNewEpisode
                      ? Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(16),
                          child: const CircularProgressIndicator(
                            color: Colors.deepPurple,
                            strokeWidth: 2,
                          ),
                        )
                      : SizedBox(
                          width: 50,
                          child: IconButton(
                            color: Colors.white,
                            iconSize: 34,
                            onPressed: () {
                              if (audioProvider.audioPlayer.state ==
                                  PlayerState.playing) {
                                audioProvider.pauseAudioPlayer();
                              } else {
                                audioProvider.resumeAudioPlayer();
                              }
                            },
                            icon: audioProvider.isPlaying
                                ? const Icon(Icons.pause_circle_filled_rounded)
                                : const Icon(Icons.play_circle_filled_rounded),
                          ),
                        ),
                  IconButton(
                    color: Colors.white,
                    iconSize: 30,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      audioProvider.playNextFormEpisodeList();
                    },
                    icon: const Icon(Icons.arrow_circle_right_rounded),
                  ),
                ],
              )
            ],
          ),
          isExpanded
              ? Column(
                  children: [
                    StreamBuilder<Duration>(
                      stream: audioProvider.audioPlayer.onPositionChanged,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // return Text("${snapshot.data!.inMinutes}:${snapshot.data!.inSeconds}".toString());
                          return Column(
                            children: [
                              Container(
                                child: SliderTheme(
                                  data: const SliderThemeData(
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0,
                                      pressedElevation: 2.0,
                                    ),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 16.0),
                                  ),
                                  child: Slider(
                                    max: audioProvider
                                        .activeAudioDuration.inSeconds
                                        .toDouble(),
                                    value: snapshot.data!.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      audioProvider.audioPlayer.seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatTime(snapshot.data!.inSeconds),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      formatTime(audioProvider
                                          .activeAudioDuration.inSeconds),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        // return Text(Duration(seconds: 5000).inMinutes.toString());
                        return Column(
                          children: [
                            Container(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.0,
                                    pressedElevation: 2.0,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 16.0),
                                ),
                                child: Slider(
                                  max: 100,
                                  value: 0,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "00:00:00",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    formatTime(audioProvider
                                        .activeAudioDuration.inSeconds
                                        .toInt()),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12)
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     IconButton(
                    //       color: Colors.white,
                    //       iconSize: 44,
                    //       onPressed: () {},
                    //       icon: const Icon(Icons.arrow_circle_left_rounded),
                    //     ),
                    //     const SizedBox(width: 24),
                    //     IconButton(
                    //       color: Colors.white,
                    //       iconSize: 54,
                    //       onPressed: () {
                    //         if (audioProvider.audioPlayer.state == PlayerState.playing) {
                    //           audioProvider.pauseAudioPlayer();
                    //         } else {
                    //           audioProvider.resumeAudioPlayer();
                    //         }
                    //       },
                    //       icon: audioProvider.isPlaying
                    //           ? const Icon(Icons.pause_circle_filled_rounded)
                    //           : const Icon(Icons.play_circle_filled_rounded),
                    //     ),
                    //     const SizedBox(width: 24),
                    //     IconButton(
                    //       color: Colors.white,
                    //       iconSize: 44,
                    //       onPressed: () {
                    //         audioProvider.audioPlayer.seek(const Duration(minutes: 50));
                    //       },
                    //       icon: const Icon(Icons.arrow_circle_right_rounded),
                    //     ),
                    //   ],
                    // )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }
}
