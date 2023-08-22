import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_popular.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:tv/bloc/tv_popular/tv_popular_event.dart';
import 'package:tv/bloc/tv_popular/tv_popular_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_popular_bloc_test.mocks.dart';

@GenerateMocks([GetTvPopular])
void main() {
  late MockGetTvPopular mockGetTvPopular;
  late TvPopularBloc tvPopularBloc;

  setUp(() {
    mockGetTvPopular = MockGetTvPopular();
    tvPopularBloc = TvPopularBloc(mockGetTvPopular);
  });

  group('tv popular', () {
    test('should emit Empty state initially', () {
      expect(tvPopularBloc.state, TvPopularEmpty());
    });

    blocTest<TvPopularBloc, TvPopularState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetTvPopular.execute())
            .thenAnswer((_) async => Right(testTvList));
        return tvPopularBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopular()),
      expect: () => [
        TvPopularLoading(),
        TvPopularHasData(testTvList),
      ],
      verify: (bloc) {
        verify(mockGetTvPopular.execute());
        return OnFetchPopular().props;
      },
    );

    blocTest<TvPopularBloc, TvPopularState>(
      'should emit Empty state when fetched data is empty',
      build: () {
        when(mockGetTvPopular.execute())
            .thenAnswer((_) async => const Right([]));
        return tvPopularBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopular()),
      expect: () => [
        TvPopularLoading(),
        TvPopularEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetTvPopular.execute());
        return OnFetchPopular().props;
      },
    );

    blocTest<TvPopularBloc, TvPopularState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetTvPopular.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvPopularBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopular()),
      expect: () => [
        TvPopularLoading(),
        TvPopularError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvPopular.execute());
        return TvPopularLoading().props;
      },
    );
  });
}
