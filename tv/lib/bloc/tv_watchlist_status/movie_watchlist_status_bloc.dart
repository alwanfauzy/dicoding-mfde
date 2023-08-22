import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_event.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_state.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_tv_watchlist.dart';

class TvWatchlistStatusBloc
    extends Bloc<TvWatchlistStatusEvent, TvWatchlistStatusState> {
  final GetTvWatchlistStatus _getWatchlistTvStatus;
  final RemoveTvWatchlist _removeTvWatchlist;
  final SaveTvWatchlist _saveTvWatchlist;

  TvWatchlistStatusBloc(
    this._getWatchlistTvStatus,
    this._removeTvWatchlist,
    this._saveTvWatchlist,
  ) : super(TvWatchlistStatusEmpty()) {
    on<OnFetchWatchlistStatus>(_onFetchWatchlistStatus);
    on<OnSaveWatchlist>(_onSaveWatchlist);
    on<OnRemoveWatchlist>(_onRemoveWatchlist);
  }

  _onFetchWatchlistStatus(
    OnFetchWatchlistStatus event,
    Emitter<TvWatchlistStatusState> emit,
  ) async {
    final id = event.id;
    final result = await _getWatchlistTvStatus.execute(id);
    emit(TvWatchlistStatusIsAdded(isAdded: result));
  }

  _onSaveWatchlist(
    OnSaveWatchlist event,
    Emitter<TvWatchlistStatusState> emit,
  ) async {
    final tv = event.tv;
    final result = await _saveTvWatchlist.execute(tv);
    result.fold(
        (failure) => emit(TvWatchlistStatusError(failure.message)),
        (success) =>
            emit(TvWatchlistStatusIsAdded(isAdded: true, message: success)));
  }

  _onRemoveWatchlist(
    OnRemoveWatchlist event,
    Emitter<TvWatchlistStatusState> emit,
  ) async {
    final tv = event.tv;
    final result = await _removeTvWatchlist.execute(tv);
    result.fold(
        (failure) => emit(TvWatchlistStatusError(failure.message)),
        (success) =>
            emit(TvWatchlistStatusIsAdded(isAdded: false, message: success)));
  }
}
