import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/bloc/movie_detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(MovieDetailEmpty()) {
    on<OnFetchDetail>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());
      final result = await _getMovieDetail.execute(id);

      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (success) => emit(MovieDetailHasData(success)),
      );
    });
  }
}
