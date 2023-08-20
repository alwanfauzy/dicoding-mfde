import 'package:core/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvSeasonModel extends Equatable {
  TvSeasonModel({
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

  factory TvSeasonModel.fromJson(Map<String, dynamic> json) => TvSeasonModel(
        id: json["id"],
        airDate: json["air_date"],
        name: json["name"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
        episodeCount: json["episode_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "air_date": airDate,
        "name": name,
        "poster_path": posterPath,
        "season_number": seasonNumber,
        "episode_count": episodeCount,
      };

  TvSeason toEntity() => TvSeason(
        id: id,
        airDate: airDate,
        name: name,
        posterPath: posterPath,
        seasonNumber: seasonNumber,
        episodeCount: episodeCount,
      );

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
