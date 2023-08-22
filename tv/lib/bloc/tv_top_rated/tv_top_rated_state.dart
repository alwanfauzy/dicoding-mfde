import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvTopRatedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvTopRatedLoading extends TvTopRatedState {}

class TvTopRatedEmpty extends TvTopRatedState {}

class TvTopRatedError extends TvTopRatedState {
  final String message;

  TvTopRatedError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvTopRatedHasData extends TvTopRatedState {
  final List<Tv> result;

  TvTopRatedHasData(this.result);

  @override
  List<Object?> get props => [result];
}
