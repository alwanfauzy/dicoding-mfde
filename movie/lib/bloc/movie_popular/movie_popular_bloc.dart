import 'package:core/domain/usecases/get_movie_popular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_popular/movie_popular_event.dart';
import 'package:movie/bloc/movie_popular/movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetMoviePopular _getMoviePopular;

  MoviePopularBloc(this._getMoviePopular) : super(MoviePopularEmpty()) {
    on<OnFetchPopular>((event, emit) async {
      emit(MoviePopularLoading());
      final result = await _getMoviePopular.execute();

      result.fold(
        (failure) => emit(MoviePopularError(failure.message)),
        (success) => success.isEmpty
            ? emit(MoviePopularEmpty())
            : emit(MoviePopularHasData(success)),
      );
    });
  }
}
