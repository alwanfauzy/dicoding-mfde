import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_now_playing.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_event.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetTvNowPlaying])
void main() {
  late MockGetTvNowPlaying mockGetTvNowPlaying;
  late TvNowPlayingBloc tvNowPlayingBloc;

  setUp(() {
    mockGetTvNowPlaying = MockGetTvNowPlaying();
    tvNowPlayingBloc = TvNowPlayingBloc(mockGetTvNowPlaying);
  });

  group('tv now playing', () {
    test('should emit Empty state initially', () {
      expect(tvNowPlayingBloc.state, TvNowPlayingEmpty());
    });

    blocTest<TvNowPlayingBloc, TvNowPlayingState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetTvNowPlaying.execute())
            .thenAnswer((_) async => Right(testTvList));
        return tvNowPlayingBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlaying()),
      expect: () => [
        TvNowPlayingLoading(),
        TvNowPlayingHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetTvNowPlaying.execute());
        return OnFetchNowPlaying().props;
      },
    );

    blocTest<TvNowPlayingBloc, TvNowPlayingState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetTvNowPlaying.execute())
            .thenAnswer((_) async => const Right([]));
        return tvNowPlayingBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlaying()),
      expect: () => [
        TvNowPlayingLoading(),
        TvNowPlayingEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetTvNowPlaying.execute());
        return OnFetchNowPlaying().props;
      },
    );

    blocTest<TvNowPlayingBloc, TvNowPlayingState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetTvNowPlaying.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvNowPlayingBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlaying()),
      expect: () => [
        TvNowPlayingLoading(),
        TvNowPlayingError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvNowPlaying.execute());
        return TvNowPlayingLoading().props;
      },
    );
  });
}
