import 'package:core/domain/usecases/get_movie_watchlist_status.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_state.dart';

class MovieWatchlistStatusBloc
    extends Bloc<MovieWatchlistStatusEvent, MovieWatchlistStatusState> {
  final GetMovieWatchlistStatus _getWatchlistMovieStatus;
  final RemoveMovieWatchlist _removeMovieWatchlist;
  final SaveMovieWatchlist _saveMovieWatchlist;

  MovieWatchlistStatusBloc(
    this._getWatchlistMovieStatus,
    this._removeMovieWatchlist,
    this._saveMovieWatchlist,
  ) : super(MovieWatchlistStatusEmpty()) {
    on<OnFetchWatchlistStatus>(_onFetchWatchlistStatus);
    on<OnSaveWatchlist>(_onSaveWatchlist);
    on<OnRemoveWatchlist>(_onRemoveWatchlist);
  }

  _onFetchWatchlistStatus(
    OnFetchWatchlistStatus event,
    Emitter<MovieWatchlistStatusState> emit,
  ) async {
    final id = event.id;
    final result = await _getWatchlistMovieStatus.execute(id);
    emit(MovieWatchlistStatusIsAdded(isAdded: result));
  }

  _onSaveWatchlist(
    OnSaveWatchlist event,
    Emitter<MovieWatchlistStatusState> emit,
  ) async {
    final movie = event.movie;
    final result = await _saveMovieWatchlist.execute(movie);
    result.fold(
        (failure) => emit(MovieWatchlistStatusError(failure.message)),
        (success) =>
            emit(MovieWatchlistStatusIsAdded(isAdded: true, message: success)));
  }

  _onRemoveWatchlist(
    OnRemoveWatchlist event,
    Emitter<MovieWatchlistStatusState> emit,
  ) async {
    final movie = event.movie;
    final result = await _removeMovieWatchlist.execute(movie);
    result.fold(
        (failure) => emit(MovieWatchlistStatusError(failure.message)),
        (success) => emit(
            MovieWatchlistStatusIsAdded(isAdded: false, message: success)));
  }
}
