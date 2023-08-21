import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieRecommendationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationsLoading extends MovieRecommendationsState {}

class MovieRecommendationsEmpty extends MovieRecommendationsState {}

class MovieRecommendationsError extends MovieRecommendationsState {
  final String message;

  MovieRecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieRecommendationsHasData extends MovieRecommendationsState {
  final List<Movie> result;

  MovieRecommendationsHasData(this.result);

  @override
  List<Object?> get props => [result];
}
