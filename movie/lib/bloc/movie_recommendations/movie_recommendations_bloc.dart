import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_event.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_state.dart';

class MovieRecommendationsBloc
    extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationsBloc(this._getMovieRecommendations)
      : super(MovieRecommendationsEmpty()) {
    on<OnFetchRecommendations>((event, emit) async {
      final id = event.id;

      emit(MovieRecommendationsLoading());
      final result = await _getMovieRecommendations.execute(id);

      result.fold(
        (failure) => emit(MovieRecommendationsError(failure.message)),
        (success) {
          if (success.isEmpty) {
            emit(MovieRecommendationsEmpty());
          } else {
            emit(MovieRecommendationsHasData(success));
          }
        },
      );
    });
  }
}
