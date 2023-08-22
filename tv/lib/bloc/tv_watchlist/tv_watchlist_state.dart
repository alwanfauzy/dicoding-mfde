import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvWatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  TvWatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvWatchlistHasData extends TvWatchlistState {
  final List<Tv> result;

  TvWatchlistHasData(this.result);

  @override
  List<Object?> get props => [result];
}
