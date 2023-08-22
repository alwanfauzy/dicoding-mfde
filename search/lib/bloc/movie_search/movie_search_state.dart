import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchEmpty extends MovieSearchState {}

class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieSearchHasData extends MovieSearchState {
  final List<Movie> result;

  MovieSearchHasData(this.result);

  @override
  List<Object?> get props => [result];
}
