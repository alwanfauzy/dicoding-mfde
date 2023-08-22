import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvWatchlistStatusEvent extends Equatable {}

class OnFetchWatchlistStatus extends TvWatchlistStatusEvent {
  final int id;

  OnFetchWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class OnSaveWatchlist extends TvWatchlistStatusEvent {
  final TvDetail tv;

  OnSaveWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class OnRemoveWatchlist extends TvWatchlistStatusEvent {
  final TvDetail tv;

  OnRemoveWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}
