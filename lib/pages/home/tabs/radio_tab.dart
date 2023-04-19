import 'dart:developer';
import 'package:sound_scrolls/utils/app_consts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../model/radio.dart';
import '../../../utils/ai_util.dart';
import '../../../widgets/drawer_widget.dart';

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  _RadioTabState createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  List<MyRadio> radios = [];
  late MyRadio _selectedRadio;
  late Color _selectedColor;
  bool _isPlaying = false;
  final sugg = [
    "Play",
    "Stop",
    "Play rock music",
    "Play 107 FM",
    "Play next",
    "Play 104 FM",
    "Pause",
    "Play previous",
    "Play pop music"
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setupAlan() {
    AlanVoice.addButton(
      "38464c610680704a458ed30c79a4695c2e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT,
      bottomMargin: 100,
      topMargin: 100,
    );
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        _playMusic(_selectedRadio.url!);
        break;

      case "play_channel":
        final id = response["id"];
        // _audioPlayer.pause();
        MyRadio newRadio = radios.firstWhere((element) => element.id == id);
        radios.remove(newRadio);
        radios.insert(0, newRadio);
        _playMusic(newRadio.url!);
        break;

      case "stop":
        _audioPlayer.stop();
        break;
      case "next":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index + 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url!);
        break;

      case "prev":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index - 1 <= 0) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url!);
        break;
      default:
        print("Command was ${response["command"]}");
        break;
    }
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(_selectedRadio.color!)!);
    print(radios);
    setState(() {});
  }

  _playMusic(String url) async {
    await _audioPlayer.setSourceUrl(url);
    log(url);
    await _audioPlayer.play(UrlSource(url));
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    log(_selectedRadio.name.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(
        radios: radios,
      ),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                  colors: [
                    AIColors.primaryColor2,
                    // _selectedColor ?? AIColors.primaryColor1,
                    Colors.red
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
              .make(),
          [
            AppBar(
              title: MyConst.appDisplayName.text.xl4.bold.white.make().shimmer(
                  primaryColor: Vx.purple300, secondaryColor: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
            ).h(100.0).p16(),
            "Start with - Hey Alan 👇".text.italic.semiBold.white.make(),
            10.heightBox,
            VxSwiper.builder(
              itemCount: sugg.length,
              height: 50.0,
              viewportFraction: 0.35,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 3),
              autoPlayCurve: Curves.linear,
              enableInfiniteScroll: true,
              itemBuilder: (context, index) {
                final s = sugg[index];
                return Chip(
                  label: s.text.make(),
                  backgroundColor: Vx.randomColor,
                );
              },
            )
          ].vStack(alignment: MainAxisAlignment.start),
          30.heightBox,
          radios != null
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 100,
                  child: VxSwiper.builder(
                    itemCount: radios.length,
                    // aspectRatio: context.mdWindowSize == MobileWindowSize.xsmall
                    //     ? 1.0
                    //     : context.mdWindowSize == MobileWindowSize.medium
                    //         ? 2.0
                    //         : 3.0,
                    aspectRatio: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index) {
                      _selectedRadio = radios[index];
                      final colorHex = radios[index].color;
                      _selectedColor = Color(int.tryParse(colorHex!)!);
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      // log(radios.toString());
                      final rad = radios[index];

                      return VxBox(
                              child: ZStack(
                        [
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: VxBox(
                              child: rad.category!.text.uppercase.white
                                  .make()
                                  .px16(),
                            )
                                .height(40)
                                .black
                                .alignCenter
                                .withRounded(value: 10.0)
                                .make(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VStack(
                              [
                                rad.name!.text.xl3.white.bold.make(),
                                5.heightBox,
                                rad.tagline!.text.sm.white.semiBold.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: [
                                Icon(
                                  CupertinoIcons.play_circle,
                                  color: Colors.white,
                                ),
                                10.heightBox,
                                "Double tap to play".text.gray300.make(),
                              ].vStack())
                        ],
                      ))
                          .clip(Clip.antiAlias)
                          .bgImage(
                            DecorationImage(
                              image: NetworkImage(rad.image!),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken),
                            ),
                          )
                          .border(color: Colors.black, width: 5.0)
                          .withRounded(value: 20.0)
                          .make()
                          .onInkDoubleTap(() {
                        _playMusic(rad.url!);
                      }).p16();
                    },
                  ).centered(),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_selectedRadio.name} FM"
                    .text
                    .white
                    .makeCentered(),
              SizedBox(height: 4),
              Icon(
                _isPlaying
                    ? CupertinoIcons.stop_circle
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                if (_isPlaying) {
                  _audioPlayer.stop();
                } else {
                  _playMusic(_selectedRadio.url!);
                }
                // _playMusic(_selectedRadio.url!);
              }),
              SizedBox(height: 4),
              if (_isPlaying) "Pause / Resume".text.white.makeCentered(),
            ].vStack(),
          ).pOnly(bottom: 14),
        ],
      ),
    );
  }
}
