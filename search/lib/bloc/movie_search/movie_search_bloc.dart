import 'package:core/domain/usecases/search_movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/bloc/movie_search/movie_search_event.dart';
import 'package:search/bloc/movie_search/movie_search_state.dart';
import 'package:search/utils/constants.dart';
import 'package:search/utils/debounce_event_transformer.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovie _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(MovieSearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(MovieSearchLoading());
      final result = await _searchMovies.execute(query);

      result.fold((failure) {
        emit(MovieSearchError(failure.message));
      }, (success) {
        if (success.isEmpty) {
          emit(MovieSearchEmpty());
        } else {
          emit(MovieSearchHasData(success));
        }
      });
    }, transformer: debounce(DURATION_DEBOUNCE));
  }
}
