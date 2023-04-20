import 'package:sound_scrolls/pages/home/tabs/podcast_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/podcast_data.dart';
import '../../../provider/audio_player_provider.dart';
import 'widgets/podcast_player.dart';

class PodCastTab extends StatefulWidget {
  PodCastTab({Key? key}) : super(key: key);

  @override
  State<PodCastTab> createState() => _PodCastTabState();
}

class _PodCastTabState extends State<PodCastTab> {
  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioPlayerProvider>(context);
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 284,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Hero(
                            tag: 'poster',
                            child: Image.asset(
                              "assets/img/data/podcast-poster.jpg",
                              filterQuality: FilterQuality.medium,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                end: Alignment.bottomCenter,
                                begin: Alignment.topCenter,
                                colors: [
                                  Color.fromARGB(0, 44, 41, 58),
                                  Color.fromARGB(0, 44, 41, 58),
                                  Color.fromARGB(0, 44, 41, 58),
                                  Color.fromARGB(25, 44, 41, 58),
                                  Color.fromARGB(50, 44, 41, 58),
                                  Color.fromARGB(100, 44, 41, 58),
                                  Color.fromARGB(120, 44, 41, 58),
                                  Color.fromARGB(150, 44, 41, 58),
                                  Color.fromARGB(180, 44, 41, 58),
                                  Color.fromARGB(200, 44, 41, 58),
                                  Color.fromARGB(230, 44, 41, 58),
                                  // Color(0xFF2C293A),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 28,
                          left: 28,
                          right: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Explore".toUpperCase(),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(
                                width: 200,
                                child: Text(
                                  "Discover Podcasts on your favorite topics.",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(height: 18),
                  SectionDividerWithTitleAndBody(
                    title: '',
                    bodyWidget: Container(
                      // height: 200,
                      // width: 200,
                      child: ListView.builder(
                        itemCount: listOfPodCasts.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        // scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return PodCastCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PodCastViewPage(podCast: listOfPodCasts[index]);
                                  },
                                ),
                              );
                            },
                            title: listOfPodCasts[index].name,
                            bodyText: listOfPodCasts[index].shortDescription,
                            imageUrl: listOfPodCasts[index].posterUrl,
                            episodeCount: listOfPodCasts[index].episodes.length,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              child: audioProvider.activePlayingPodCast != null
                  ? PodcastPlayer(
                      activeIndex: audioProvider.activePodCastEpisode!,
                      activePodCast: audioProvider.activePlayingPodCast!,
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class PodCastCard extends StatelessWidget {
  const PodCastCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    required this.bodyText,
    required this.episodeCount,
  });

  final String title;
  final String bodyText;
  final int episodeCount;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        // color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 124,
              width: 124,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 239, 239, 239),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$episodeCount Episodes",
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    bodyText,
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionDividerWithTitleAndBody extends StatelessWidget {
  const SectionDividerWithTitleAndBody({Key? key, required this.title, required this.bodyWidget}) : super(key: key);

  final String title;
  final Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 227, 227, 227),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // SizedBox(height: 16),
          bodyWidget,
        ],
      ),
    );
  }
}
