import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/search_movie.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/bloc/movie_search/movie_search_bloc.dart';
import 'package:search/bloc/movie_search/movie_search_event.dart';
import 'package:search/bloc/movie_search/movie_search_state.dart';

import 'movie_search_page_test.mocks.dart';

@GenerateMocks([SearchMovie])
void main() {
  late MockSearchMovie mockSearchMovie;
  late MovieSearchBloc movieSearchBloc;

  setUp(() {
    mockSearchMovie = MockSearchMovie();
    movieSearchBloc = MovieSearchBloc(mockSearchMovie);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  group('search movie', () {
    test('should emit Empty state initially', () {
      expect(movieSearchBloc.state, MovieSearchEmpty());
    });
    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockSearchMovie.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovie.execute(tQuery));
        return OnQueryChanged(tQuery).props;
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit Error state when the searched data failed to fetch',
      build: () {
        when(mockSearchMovie.execute(tQuery)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovie.execute(tQuery));
        return MovieSearchLoading().props;
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit Empty state when the searched data is empty',
      build: () {
        when(mockSearchMovie.execute(tQuery))
            .thenAnswer((_) async => const Right([]));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchMovie.execute(tQuery));
      },
    );
  });
}
