import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_now_playing.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_event.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetMovieNowPlaying])
void main() {
  late MockGetMovieNowPlaying mockGetMovieNowPlaying;
  late MovieNowPlayingBloc movieNowPlayingBloc;

  setUp(() {
    mockGetMovieNowPlaying = MockGetMovieNowPlaying();
    movieNowPlayingBloc = MovieNowPlayingBloc(mockGetMovieNowPlaying);
  });

  group('movie now playing', () {
    test('should emit Empty state initially', () {
      expect(movieNowPlayingBloc.state, MovieNowPlayingEmpty());
    });

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetMovieNowPlaying.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return movieNowPlayingBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingHasData(testMovieList),
      ],
      verify: (bloc) {
        verify(mockGetMovieNowPlaying.execute());
        return OnFetchNowPlaying().props;
      },
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetMovieNowPlaying.execute())
            .thenAnswer((_) async => const Right([]));
        return movieNowPlayingBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetMovieNowPlaying.execute());
        return OnFetchNowPlaying().props;
      },
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetMovieNowPlaying.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieNowPlayingBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieNowPlaying.execute());
        return MovieNowPlayingLoading().props;
      },
    );
  });
}
