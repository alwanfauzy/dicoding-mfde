import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends MovieSearchState {}

class Empty extends MovieSearchState {}

class Error extends MovieSearchState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}

class HasData extends MovieSearchState {
  final List<Movie> result;

  HasData(this.result);

  @override
  List<Object?> get props => [result];
}
