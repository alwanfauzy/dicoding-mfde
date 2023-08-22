import 'package:core/domain/usecases/get_tv_popular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_popular/tv_popular_event.dart';
import 'package:tv/bloc/tv_popular/tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetTvPopular _getTvPopular;

  TvPopularBloc(this._getTvPopular) : super(TvPopularEmpty()) {
    on<OnFetchPopular>((event, emit) async {
      emit(TvPopularLoading());
      final result = await _getTvPopular.execute();

      result.fold(
        (failure) => emit(TvPopularError(failure.message)),
        (success) => success.isEmpty
            ? emit(TvPopularEmpty())
            : emit(TvPopularHasData(success)),
      );
    });
  }
}
