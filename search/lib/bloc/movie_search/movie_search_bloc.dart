import 'package:core/domain/usecases/search_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';
import 'package:search/bloc/movie_search/movie_search_event.dart';
import 'package:search/bloc/movie_search/movie_search_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(Empty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(Loading());
      final result = await _searchMovies.execute(query);

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
