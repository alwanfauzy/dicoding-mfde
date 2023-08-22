import 'package:core/domain/usecases/get_tv_now_playing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_event.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_state.dart';

class TvNowPlayingBloc extends Bloc<TvNowPlayingEvent, TvNowPlayingState> {
  final GetTvNowPlaying _getTvNowPlaying;

  TvNowPlayingBloc(this._getTvNowPlaying) : super(TvNowPlayingEmpty()) {
    on<OnFetchNowPlaying>((event, emit) async {
      emit(TvNowPlayingLoading());
      final result = await _getTvNowPlaying.execute();

      result.fold(
        (failure) => emit(TvNowPlayingError(failure.message)),
        (success) => success.isEmpty
            ? emit(TvNowPlayingEmpty())
            : emit(TvNowPlayingHasData(success)),
      );
    });
  }
}
