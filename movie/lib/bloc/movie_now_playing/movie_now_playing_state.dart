import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieNowPlayingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieNowPlayingLoading extends MovieNowPlayingState {}

class MovieNowPlayingEmpty extends MovieNowPlayingState {}

class MovieNowPlayingError extends MovieNowPlayingState {
  final String message;

  MovieNowPlayingError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieNowPlayingHasData extends MovieNowPlayingState {
  final List<Movie> result;

  MovieNowPlayingHasData(this.result);

  @override
  List<Object?> get props => [result];
}
