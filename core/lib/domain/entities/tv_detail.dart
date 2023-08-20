import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  const TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.runtime,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalName;
  final String overview;
  final String posterPath;
  final int? runtime;
  final String name;
  final double voteAverage;
  final int voteCount;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<TvSeason> seasons;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalName,
        overview,
        posterPath,
        name,
        voteAverage,
        voteCount,
        numberOfSeasons,
        numberOfEpisodes,
        seasons,
      ];
}
