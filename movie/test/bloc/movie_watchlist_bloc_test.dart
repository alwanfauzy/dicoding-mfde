import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_watchlist.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_event.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetMovieWatchlist])
void main() {
  late MockGetMovieWatchlist mockGetMovieWatchlist;
  late MovieWatchlistBloc movieWatchlistBloc;

  setUp(() {
    mockGetMovieWatchlist = MockGetMovieWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(mockGetMovieWatchlist);
  });

  group('movie watchlist', () {
    test('should emit Empty state initially', () {
      expect(movieWatchlistBloc.state, MovieWatchlistEmpty());
    });

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetMovieWatchlist.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieWatchlist.execute());
        return OnFetchWatchlist().props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetMovieWatchlist.execute())
            .thenAnswer((_) async => const Right([]));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetMovieWatchlist.execute());
        return OnFetchWatchlist().props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetMovieWatchlist.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieWatchlist.execute());
        return MovieWatchlistLoading().props;
      },
    );
  });
}
