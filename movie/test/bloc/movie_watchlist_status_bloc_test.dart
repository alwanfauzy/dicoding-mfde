import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_watchlist_status.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks(
    [GetMovieWatchlistStatus, RemoveMovieWatchlist, SaveMovieWatchlist])
void main() {
  late MockGetMovieWatchlistStatus mockGetMovieWatchlistStatus;
  late MockRemoveMovieWatchlist mockRemoveMovieWatchlist;
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;

  late MovieWatchlistStatusBloc movieWatchlistStatusBloc;

  setUp(() {
    mockGetMovieWatchlistStatus = MockGetMovieWatchlistStatus();
    mockRemoveMovieWatchlist = MockRemoveMovieWatchlist();
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    movieWatchlistStatusBloc = MovieWatchlistStatusBloc(
      mockGetMovieWatchlistStatus,
      mockRemoveMovieWatchlist,
      mockSaveMovieWatchlist,
    );
  });

  const tId = 1;
  const tWatchlistStatus = true;

  group('movie watchlist status', () {
    test('should emit Empty state initially', () {
      expect(movieWatchlistStatusBloc.state, MovieWatchlistStatusEmpty());
    });

    blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
      'should emit IsAdded(status) state when data successfully fetched',
      build: () {
        when(mockGetMovieWatchlistStatus.execute(tId))
            .thenAnswer((_) async => tWatchlistStatus);
        return movieWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistStatus(tId)),
      expect: () => [
        MovieWatchlistStatusIsAdded(isAdded: tWatchlistStatus),
      ],
      verify: (bloc) {
        verify(mockGetMovieWatchlistStatus.execute(tId));
        return OnFetchWatchlistStatus(tId).props;
      },
    );

    blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
      'should emit IsAdded(true, message) state when successfully save data',
      build: () {
        when(mockSaveMovieWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right(MESSAGE_ADD_WATCHLIST));
        return movieWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistStatusIsAdded(
          isAdded: true,
          message: MESSAGE_ADD_WATCHLIST,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveMovieWatchlist.execute(testMovieDetail));
        return OnSaveWatchlist(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
      'should emit IsAdded(false, message) state when successfully remove data',
      build: () {
        when(mockRemoveMovieWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right(MESSAGE_REMOVE_WATCHLIST));
        return movieWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistStatusIsAdded(
          isAdded: false,
          message: MESSAGE_REMOVE_WATCHLIST,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveMovieWatchlist.execute(testMovieDetail));
        return OnRemoveWatchlist(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
      'should emit Error state when failed to save data',
      build: () {
        when(mockSaveMovieWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistStatusError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSaveMovieWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
      'should emit Error state when failed to remove data',
      build: () {
        when(mockRemoveMovieWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistStatusError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockRemoveMovieWatchlist.execute(testMovieDetail));
      },
    );
  });
}
