import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvPopularState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvPopularLoading extends TvPopularState {}

class TvPopularEmpty extends TvPopularState {}

class TvPopularError extends TvPopularState {
  final String message;

  TvPopularError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvPopularHasData extends TvPopularState {
  final List<Tv> result;

  TvPopularHasData(this.result);

  @override
  List<Object?> get props => [result];
}
