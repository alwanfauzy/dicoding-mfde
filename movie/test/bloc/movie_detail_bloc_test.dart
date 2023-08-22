import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/bloc/movie_detail/movie_detail_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  const tId = 1;

  group('movie detail', () {
    test('should emit Empty state initially', () {
      expect(movieDetailBloc.state, MovieDetailEmpty());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(OnFetchDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailHasData(testMovieDetail),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        return OnFetchDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(OnFetchDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        return MovieDetailLoading().props;
      },
    );
  });
}
