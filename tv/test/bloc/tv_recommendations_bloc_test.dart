import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_event.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late MockGetTvRecommendations mockGetTvRecommendations;
  late TvRecommendationsBloc tvRecommendationsBloc;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvRecommendationsBloc = TvRecommendationsBloc(mockGetTvRecommendations);
  });

  const tId = 1;

  group('tv recommendations', () {
    test('should emit Empty state initially', () {
      expect(tvRecommendationsBloc.state, TvRecommendationsEmpty());
    });

    blocTest<TvRecommendationsBloc, TvRecommendationsState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvList));
        return tvRecommendationsBloc;
      },
      act: (bloc) => bloc.add(OnFetchRecommendations(tId)),
      expect: () => [
        TvRecommendationsLoading(),
        TvRecommendationsHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
        return OnFetchRecommendations(tId).props;
      },
    );

    blocTest<TvRecommendationsBloc, TvRecommendationsState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return tvRecommendationsBloc;
      },
      act: (bloc) => bloc.add(OnFetchRecommendations(tId)),
      expect: () => [
        TvRecommendationsLoading(),
        TvRecommendationsEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
        return OnFetchRecommendations(tId).props;
      },
    );

    blocTest<TvRecommendationsBloc, TvRecommendationsState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetTvRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvRecommendationsBloc;
      },
      act: (bloc) => bloc.add(OnFetchRecommendations(tId)),
      expect: () => [
        TvRecommendationsLoading(),
        TvRecommendationsError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
        return TvRecommendationsLoading().props;
      },
    );
  });
}
