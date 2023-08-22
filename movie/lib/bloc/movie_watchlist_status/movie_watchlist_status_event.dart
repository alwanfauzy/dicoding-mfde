import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieWatchlistStatusEvent extends Equatable {}

class OnFetchWatchlistStatus extends MovieWatchlistStatusEvent {
  final int id;

  OnFetchWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class OnSaveWatchlist extends MovieWatchlistStatusEvent {
  final MovieDetail movie;

  OnSaveWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class OnRemoveWatchlist extends MovieWatchlistStatusEvent {
  final MovieDetail movie;

  OnRemoveWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}
