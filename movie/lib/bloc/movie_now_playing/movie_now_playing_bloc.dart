import 'package:core/domain/usecases/get_movie_now_playing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_event.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_state.dart';

class MovieNowPlayingBloc
    extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetMovieNowPlaying _getMovieNowPlaying;

  MovieNowPlayingBloc(this._getMovieNowPlaying)
      : super(MovieNowPlayingEmpty()) {
    on<OnFetchNowPlaying>((event, emit) async {
      emit(MovieNowPlayingLoading());
      final result = await _getMovieNowPlaying.execute();

      result.fold(
        (failure) => emit(MovieNowPlayingError(failure.message)),
        (success) => success.isEmpty
            ? emit(MovieNowPlayingEmpty())
            : emit(MovieNowPlayingHasData(success)),
      );
    });
  }
}
