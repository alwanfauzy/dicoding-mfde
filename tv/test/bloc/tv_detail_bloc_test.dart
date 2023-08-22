import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/bloc/tv_detail/tv_detail_state.dart';

import '../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc tvDetailBloc;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(mockGetTvDetail);
  });

  const tId = 1;

  group('tv detail', () {
    test('should emit Empty state initially', () {
      expect(tvDetailBloc.state, TvDetailEmpty());
    });

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvDetail));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(OnFetchDetail(tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailHasData(testTvDetail),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        return OnFetchDetail(tId).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit Error state when data failed to fetch',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(OnFetchDetail(tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        return TvDetailLoading().props;
      },
    );
  });
}
