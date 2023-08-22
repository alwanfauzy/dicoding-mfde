import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_event.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_state.dart';
import 'package:core/domain/usecases/get_tv_watchlist.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetTvWatchlist _getWatchlistTvs;

  TvWatchlistBloc(this._getWatchlistTvs) : super(TvWatchlistEmpty()) {
    on<OnFetchWatchlist>((event, emit) async {
      emit(TvWatchlistLoading());
      final result = await _getWatchlistTvs.execute();

      result.fold(
        (failure) => emit(TvWatchlistError(failure.message)),
        (success) => success.isEmpty
            ? emit(TvWatchlistEmpty())
            : emit(TvWatchlistHasData(success)),
      );
    });
  }
}
