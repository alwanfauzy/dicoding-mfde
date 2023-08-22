import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_event.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_state.dart';

class TvRecommendationsBloc
    extends Bloc<TvRecommendationsEvent, TvRecommendationsState> {
  final GetTvRecommendations _getTvRecommendations;

  TvRecommendationsBloc(this._getTvRecommendations)
      : super(TvRecommendationsEmpty()) {
    on<OnFetchRecommendations>((event, emit) async {
      final id = event.id;

      emit(TvRecommendationsLoading());
      final result = await _getTvRecommendations.execute(id);

      result.fold(
        (failure) => emit(TvRecommendationsError(failure.message)),
        (success) {
          if (success.isEmpty) {
            emit(TvRecommendationsEmpty());
          } else {
            emit(TvRecommendationsHasData(success));
          }
        },
      );
    });
  }
}
