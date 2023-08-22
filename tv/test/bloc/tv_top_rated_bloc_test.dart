import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_top_rated.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_event.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTvTopRated])
void main() {
  late MockGetTvTopRated mockGetTvTopRated;
  late TvTopRatedBloc tvTopRatedBloc;

  setUp(() {
    mockGetTvTopRated = MockGetTvTopRated();
    tvTopRatedBloc = TvTopRatedBloc(mockGetTvTopRated);
  });

  group('tv top rated', () {
    test('should emit Empty state initially', () {
      expect(tvTopRatedBloc.state, TvTopRatedEmpty());
    });

    blocTest<TvTopRatedBloc, TvTopRatedState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetTvTopRated.execute())
            .thenAnswer((_) async => Right(testTvList));
        return tvTopRatedBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRated()),
      expect: () => [
        TvTopRatedLoading(),
        TvTopRatedHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetTvTopRated.execute());
        return OnFetchTopRated().props;
      },
    );

    blocTest<TvTopRatedBloc, TvTopRatedState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetTvTopRated.execute())
            .thenAnswer((_) async => const Right([]));
        return tvTopRatedBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRated()),
      expect: () => [
        TvTopRatedLoading(),
        TvTopRatedEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetTvTopRated.execute());
        return OnFetchTopRated().props;
      },
    );

    blocTest<TvTopRatedBloc, TvTopRatedState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetTvTopRated.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvTopRatedBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRated()),
      expect: () => [
        TvTopRatedLoading(),
        TvTopRatedError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvTopRated.execute());
        return TvTopRatedLoading().props;
      },
    );
  });
}
