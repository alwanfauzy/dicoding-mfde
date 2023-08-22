import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvNowPlayingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvNowPlayingLoading extends TvNowPlayingState {}

class TvNowPlayingEmpty extends TvNowPlayingState {}

class TvNowPlayingError extends TvNowPlayingState {
  final String message;

  TvNowPlayingError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvNowPlayingHasData extends TvNowPlayingState {
  final List<Tv> result;

  TvNowPlayingHasData(this.result);

  @override
  List<Object?> get props => [result];
}
