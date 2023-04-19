import 'package:sound_scrolls/model/podcast_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerProvider with ChangeNotifier {
  final audioPlayer = AudioPlayer();
  Duration activeAudioDuration = Duration.zero;
  bool isPlaying = false;
  //
  bool isLoadingNewEpisode = true;
  //
  PodCast? activePlayingPodCast;
  int? activePodCastEpisode;
  //
  setPlayPauseFunc(bool newValue) {
    isPlaying = newValue;
    notifyListeners();
  }

  setActivePodCast(
      {required PodCast activePodCast, required int activeEpisodeIndex}) {
    activePlayingPodCast = activePodCast;
    activePodCastEpisode = activeEpisodeIndex;
    notifyListeners();
  }

  setAudioSource(String audioFileUrl) async {
    await audioPlayer.setSourceUrl(audioFileUrl);
  }

  playAudioPlayer(String audioFileUrl) async {
    await audioPlayer.play(UrlSource(audioFileUrl)).whenComplete(() {
      setPlayPauseFunc(true);
      isLoadingNewEpisode = false;
    });
    activeAudioDuration = await audioPlayer.getDuration() ?? Duration.zero;

    notifyListeners();
  }

  pauseAudioPlayer() async {
    await audioPlayer.pause();
    setPlayPauseFunc(false);
  }

  resumeAudioPlayer() async {
    await audioPlayer.resume();
    setPlayPauseFunc(true);
  }

  stopAudioPlayer(String audioFileUrl) async {
    await audioPlayer.stop();
    setPlayPauseFunc(false);
  }

  playNextFormEpisodeList() {
    // check active podcast should not be null
    if (activePlayingPodCast != null) {
      // if playing episode is not last episode
      if (activePodCastEpisode! + 1 <= activePlayingPodCast!.episodes.length) {
        // if all good then play next episode audio form url
        activePodCastEpisode = activePodCastEpisode! + 1;
        isLoadingNewEpisode = true;
        playAudioPlayer(activePlayingPodCast!
            .episodes[activePodCastEpisode! + 1].audioSourceUrl);
      }
    }

    notifyListeners();
  }

  playPreviewsFormEpisodeList() {
    // check active podcast should not be null
    if (activePlayingPodCast != null) {
      // if playing episode is not first episode
      if (activePodCastEpisode != 0) {
        // if all good then play next episode audio form url
        playAudioPlayer(activePlayingPodCast!
            .episodes[activePodCastEpisode! - 1].audioSourceUrl);
        activePodCastEpisode = activePodCastEpisode! - 1;
        isLoadingNewEpisode = true;
      }
    }
    notifyListeners();
  }
}
