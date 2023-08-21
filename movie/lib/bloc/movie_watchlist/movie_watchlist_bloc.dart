import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_event.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;

  MovieWatchlistBloc(this._getWatchlistMovies) : super(MovieWatchlistEmpty()) {
    on<OnFetchWatchlist>((event, emit) async {
      emit(MovieWatchlistLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(MovieWatchlistError(failure.message)),
        (success) => success.isEmpty
            ? emit(MovieWatchlistEmpty())
            : emit(MovieWatchlistHasData(success)),
      );
    });
  }
}
