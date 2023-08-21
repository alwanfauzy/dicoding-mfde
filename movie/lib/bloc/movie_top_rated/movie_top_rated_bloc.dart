import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_event.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies _getMovieTopRated;

  MovieTopRatedBloc(this._getMovieTopRated) : super(MovieTopRatedEmpty()) {
    on<OnFetchTopRated>((event, emit) async {
      emit(MovieTopRatedLoading());
      final result = await _getMovieTopRated.execute();

      result.fold(
        (failure) => emit(MovieTopRatedError(failure.message)),
        (success) => success.isEmpty
            ? emit(MovieTopRatedEmpty())
            : emit(MovieTopRatedHasData(success)),
      );
    });
  }
}
