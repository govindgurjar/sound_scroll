class PodCast {
  final int id;
  final String name;
  final String shortDescription;
  final String posterUrl;
  final List<PodCastEpisode> episodes;

  PodCast({
    required this.name,
    required this.id,
    required this.shortDescription,
    required this.episodes,
    required this.posterUrl,
  });
}

class PodCastEpisode {
  final String title;
  final String shortDescription;
  final String posterUrl;
  final String audioSourceUrl;

  PodCastEpisode({
    required this.title,
    required this.shortDescription,
    required this.posterUrl,
    required this.audioSourceUrl,
  });
}
