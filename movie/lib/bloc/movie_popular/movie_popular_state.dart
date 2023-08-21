import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MoviePopularState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoviePopularLoading extends MoviePopularState {}

class MoviePopularEmpty extends MoviePopularState {}

class MoviePopularError extends MoviePopularState {
  final String message;

  MoviePopularError(this.message);

  @override
  List<Object?> get props => [message];
}

class MoviePopularHasData extends MoviePopularState {
  final List<Movie> result;

  MoviePopularHasData(this.result);

  @override
  List<Object?> get props => [result];
}
