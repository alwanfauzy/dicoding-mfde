import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_popular.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:movie/bloc/movie_popular/movie_popular_event.dart';
import 'package:movie/bloc/movie_popular/movie_popular_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_popular_bloc_test.mocks.dart';

@GenerateMocks([GetMoviePopular])
void main() {
  late MockGetMoviePopular mockGetMoviePopular;
  late MoviePopularBloc moviePopularBloc;

  setUp(() {
    mockGetMoviePopular = MockGetMoviePopular();
    moviePopularBloc = MoviePopularBloc(mockGetMoviePopular);
  });

  group('movie popular', () {
    test('should emit Empty state initially', () {
      expect(moviePopularBloc.state, MoviePopularEmpty());
    });

    blocTest<MoviePopularBloc, MoviePopularState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetMoviePopular.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return moviePopularBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopular()),
      expect: () => [
        MoviePopularLoading(),
        MoviePopularHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMoviePopular.execute());
        return OnFetchPopular().props;
      },
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetMoviePopular.execute())
            .thenAnswer((_) async => const Right([]));
        return moviePopularBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopular()),
      expect: () => [
        MoviePopularLoading(),
        MoviePopularEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetMoviePopular.execute());
        return OnFetchPopular().props;
      },
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetMoviePopular.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return moviePopularBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopular()),
      expect: () => [
        MoviePopularLoading(),
        MoviePopularError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMoviePopular.execute());
        return MoviePopularLoading().props;
      },
    );
  });
}
