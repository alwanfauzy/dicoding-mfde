import 'package:equatable/equatable.dart';

class TvSeason extends Equatable {
  TvSeason({
    required this.id,
    required this.airDate,
    required this.name,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
  });

  final int id;
  final String? airDate;
  final String name;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;

  @override
  List<Object?> get props => [
        id,
        airDate,
        name,
        posterPath,
        seasonNumber,
        episodeCount,
      ];
}
