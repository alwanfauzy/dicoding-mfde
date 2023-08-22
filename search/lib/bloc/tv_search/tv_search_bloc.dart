import 'package:core/domain/usecases/search_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/bloc/tv_search/tv_search_event.dart';
import 'package:search/bloc/tv_search/tv_search_state.dart';
import 'package:search/utils/constants.dart';
import 'package:search/utils/debounce_event_transformer.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv _searchTv;

  TvSearchBloc(this._searchTv) : super(TvSearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(TvSearchLoading());
      final result = await _searchTv.execute(query);

      result.fold((failure) {
        emit(TvSearchError(failure.message));
      }, (success) {
        if (success.isEmpty) {
          emit(TvSearchEmpty());
        } else {
          emit(TvSearchHasData(success));
        }
      });
    }, transformer: debounce(DURATION_DEBOUNCE));
  }
}
