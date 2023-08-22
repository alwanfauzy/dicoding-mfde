import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_watchlist.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_event.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetTvWatchlist])
void main() {
  late MockGetTvWatchlist mockGetTvWatchlist;
  late TvWatchlistBloc tvWatchlistBloc;

  setUp(() {
    mockGetTvWatchlist = MockGetTvWatchlist();
    tvWatchlistBloc = TvWatchlistBloc(mockGetTvWatchlist);
  });

  group('tv watchlist', () {
    test('should emit Empty state initially', () {
      expect(tvWatchlistBloc.state, TvWatchlistEmpty());
    });

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetTvWatchlist.execute())
            .thenAnswer((_) async => Right(testTvList));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetTvWatchlist.execute());
        return OnFetchWatchlist().props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetTvWatchlist.execute())
            .thenAnswer((_) async => const Right([]));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetTvWatchlist.execute());
        return OnFetchWatchlist().props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetTvWatchlist.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvWatchlist.execute());
        return TvWatchlistLoading().props;
      },
    );
  });
}
