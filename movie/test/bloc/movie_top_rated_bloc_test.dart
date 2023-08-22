import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_top_rated.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_event.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetMovieTopRated])
void main() {
  late MockGetMovieTopRated mockGetMovieTopRated;
  late MovieTopRatedBloc movieTopRatedBloc;

  setUp(() {
    mockGetMovieTopRated = MockGetMovieTopRated();
    movieTopRatedBloc = MovieTopRatedBloc(mockGetMovieTopRated);
  });

  group('movie top rated', () {
    test('should emit Empty state initially', () {
      expect(movieTopRatedBloc.state, MovieTopRatedEmpty());
    });

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetMovieTopRated.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return movieTopRatedBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRated()),
      expect: () => [
        MovieTopRatedLoading(),
        MovieTopRatedHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieTopRated.execute());
        return OnFetchTopRated().props;
      },
    );

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetMovieTopRated.execute())
            .thenAnswer((_) async => const Right([]));
        return movieTopRatedBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRated()),
      expect: () => [
        MovieTopRatedLoading(),
        MovieTopRatedEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetMovieTopRated.execute());
        return OnFetchTopRated().props;
      },
    );

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetMovieTopRated.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieTopRatedBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRated()),
      expect: () => [
        MovieTopRatedLoading(),
        MovieTopRatedError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieTopRated.execute());
        return MovieTopRatedLoading().props;
      },
    );
  });
}
