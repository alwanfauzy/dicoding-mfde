import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class TvSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends TvSearchState {}

class Empty extends TvSearchState {}

class Error extends TvSearchState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}

class HasData extends TvSearchState {
  final List<Movie> result;

  HasData(this.result);

  @override
  List<Object?> get props => [result];
}
