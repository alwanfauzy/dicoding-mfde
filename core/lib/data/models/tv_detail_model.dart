import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_season_model.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final int? runtime;
  final String status;
  final String tagline;
  final String name;
  final double voteAverage;
  final int voteCount;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<TvSeasonModel> seasons;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        runtime: json["runtime"],
        status: json["status"],
        tagline: json["tagline"],
        name: json["name"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        numberOfSeasons: json["number_of_seasons"],
        numberOfEpisodes: json["number_of_episodes"],
        seasons: List<TvSeasonModel>.from(
            json["seasons"].map((x) => TvSeasonModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "name": name,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "number_of_seasons": numberOfSeasons,
        "number_of_episodes": numberOfEpisodes,
        "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
      };

  TvDetail toEntity() {
    return TvDetail(
      adult: adult,
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      runtime: runtime,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
      numberOfSeasons: numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
      seasons: List<TvSeason>.from(seasons.map((x) => x.toEntity())),
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        homepage,
        id,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        runtime,
        status,
        tagline,
        name,
        voteAverage,
        voteCount,
        numberOfSeasons,
        numberOfEpisodes,
        seasons,
      ];
}
