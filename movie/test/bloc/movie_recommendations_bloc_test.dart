import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_event.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsBloc movieRecommendationsBloc;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc =
        MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  const tId = 1;

  group('movie recommendations', () {
    test('should emit Empty state initially', () {
      expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
    });

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(OnFetchRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
        return OnFetchRecommendations(tId).props;
      },
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(OnFetchRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
        return OnFetchRecommendations(tId).props;
      },
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(OnFetchRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
        return MovieRecommendationsLoading().props;
      },
    );
  });
}
