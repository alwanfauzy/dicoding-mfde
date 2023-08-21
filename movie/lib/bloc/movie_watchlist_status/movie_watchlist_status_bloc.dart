import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_movie_status.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_state.dart';

class MovieWatchlistStatusBloc
    extends Bloc<MovieWatchlistStatusEvent, MovieWatchlistStatusState> {
  final GetWatchlistMovieStatus _getWatchlistMovieStatus;
  final RemoveMovieWatchlist _removeMovieWatchlist;
  final SaveMovieWatchlist _saveMovieWatchlist;

  MovieWatchlistStatusBloc(
    this._getWatchlistMovieStatus,
    this._removeMovieWatchlist,
    this._saveMovieWatchlist,
  ) : super(MovieWatchlistStatusEmpty()) {
    on<OnFetchWatchlistStatus>(_onFetchWatchlistStatus);
    on<OnAddRemoveWatchlist>(_onAddRemoveWatchlist);
  }

  _onFetchWatchlistStatus(
    OnFetchWatchlistStatus event,
    Emitter<MovieWatchlistStatusState> emit,
  ) async {
    final id = event.id;
    final result = await _getWatchlistMovieStatus.execute(id);
    emit(MovieWatchlistStatusIsAdded(result));
  }

  _onAddRemoveWatchlist(
    OnAddRemoveWatchlist event,
    Emitter<MovieWatchlistStatusState> emit,
  ) async {
    final movie = event.movie;

    final shouldAdd = !(await _getWatchlistMovieStatus.execute(movie.id));
    (shouldAdd)
        ? await _onAddWatchlist(emit, movie)
        : await _onRemoveWatchlist(emit, movie);

    emit(MovieWatchlistStatusIsAdded(shouldAdd));
  }

  _onAddWatchlist(
    Emitter<MovieWatchlistStatusState> emit,
    MovieDetail movie,
  ) async {
    final result = await _saveMovieWatchlist.execute(movie);
    result.fold(
      (failure) => emit(MovieWatchlistStatusError(failure.message)),
      (success) => emit(MovieWatchlistStatusMessage(success)),
    );
  }

  _onRemoveWatchlist(
    Emitter<MovieWatchlistStatusState> emit,
    MovieDetail movie,
  ) async {
    final result = await _removeMovieWatchlist.execute(movie);
    result.fold(
      (failure) => emit(MovieWatchlistStatusError(failure.message)),
      (success) => emit(MovieWatchlistStatusMessage(success)),
    );
  }
}
