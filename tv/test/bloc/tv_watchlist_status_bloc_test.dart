import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_tv_watchlist.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_event.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([GetTvWatchlistStatus, RemoveTvWatchlist, SaveTvWatchlist])
void main() {
  late MockGetTvWatchlistStatus mockGetTvWatchlistStatus;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;
  late MockSaveTvWatchlist mockSaveTvWatchlist;

  late TvWatchlistStatusBloc tvWatchlistStatusBloc;

  setUp(() {
    mockGetTvWatchlistStatus = MockGetTvWatchlistStatus();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    tvWatchlistStatusBloc = TvWatchlistStatusBloc(
      mockGetTvWatchlistStatus,
      mockRemoveTvWatchlist,
      mockSaveTvWatchlist,
    );
  });

  const tId = 1;
  const tWatchlistStatus = true;

  group('tv watchlist status', () {
    test('should emit Empty state initially', () {
      expect(tvWatchlistStatusBloc.state, TvWatchlistStatusEmpty());
    });

    blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
      'should emit IsAdded(status) state when data successfully fetched',
      build: () {
        when(mockGetTvWatchlistStatus.execute(tId))
            .thenAnswer((_) async => tWatchlistStatus);
        return tvWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistStatus(tId)),
      expect: () => [
        TvWatchlistStatusIsAdded(isAdded: tWatchlistStatus),
      ],
      verify: (bloc) {
        verify(mockGetTvWatchlistStatus.execute(tId));
        return OnFetchWatchlistStatus(tId).props;
      },
    );

    blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
      'should emit IsAdded(true, message) state when successfully save data',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right(MESSAGE_ADD_WATCHLIST));
        return tvWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlist(testTvDetail)),
      expect: () => [
        TvWatchlistStatusIsAdded(
          isAdded: true,
          message: MESSAGE_ADD_WATCHLIST,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveTvWatchlist.execute(testTvDetail));
        return OnSaveWatchlist(testTvDetail).props;
      },
    );

    blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
      'should emit IsAdded(false, message) state when successfully remove data',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right(MESSAGE_REMOVE_WATCHLIST));
        return tvWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlist(testTvDetail)),
      expect: () => [
        TvWatchlistStatusIsAdded(
          isAdded: false,
          message: MESSAGE_REMOVE_WATCHLIST,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveTvWatchlist.execute(testTvDetail));
        return OnRemoveWatchlist(testTvDetail).props;
      },
    );

    blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
      'should emit Error state when failed to save data',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlist(testTvDetail)),
      expect: () => [
        TvWatchlistStatusError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSaveTvWatchlist.execute(testTvDetail));
      },
    );

    blocTest<TvWatchlistStatusBloc, TvWatchlistStatusState>(
      'should emit Error state when failed to remove data',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvWatchlistStatusBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlist(testTvDetail)),
      expect: () => [
        TvWatchlistStatusError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockRemoveTvWatchlist.execute(testTvDetail));
      },
    );
  });
}
