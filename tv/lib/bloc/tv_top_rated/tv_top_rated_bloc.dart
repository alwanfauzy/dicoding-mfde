import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_event.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_state.dart';
import 'package:core/domain/usecases/get_tv_top_rated.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTvTopRated _getTvTopRated;

  TvTopRatedBloc(this._getTvTopRated) : super(TvTopRatedEmpty()) {
    on<OnFetchTopRated>((event, emit) async {
      emit(TvTopRatedLoading());
      final result = await _getTvTopRated.execute();

      result.fold(
        (failure) => emit(TvTopRatedError(failure.message)),
        (success) => success.isEmpty
            ? emit(TvTopRatedEmpty())
            : emit(TvTopRatedHasData(success)),
      );
    });
  }
}
