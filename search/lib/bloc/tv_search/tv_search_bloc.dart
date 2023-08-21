import 'package:core/domain/usecases/search_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';
import 'package:search/bloc/tv_search/tv_search_event.dart';
import 'package:search/bloc/tv_search/tv_search_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv _searchTv;

  TvSearchBloc(this._searchTv) : super(Empty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(Loading());
      final result = await _searchTv.execute(query);

      result.fold((failure) {
        emit(Error(failure.message));
      }, (success) {
        if (success.isEmpty) {
          emit(Empty());
        } else {
          emit(HasData(success));
        }
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
