import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/bloc/tv_search/tv_search_bloc.dart';
import 'package:search/bloc/tv_search/tv_search_event.dart';
import 'package:search/bloc/tv_search/tv_search_state.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late TvSearchBloc tvSearchBloc;

  setUp(() {
    mockSearchTv = MockSearchTv();
    tvSearchBloc = TvSearchBloc(mockSearchTv);
  });

  final tTvModel = Tv(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalNam',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTvModel];
  const tQuery = 'spiderman';

  group('search tv', () {
    test('should emit Empty state initially', () {
      expect(tvSearchBloc.state, TvSearchEmpty());
    });

    blocTest<TvSearchBloc, TvSearchState>(
      'should emit HasData state when data successfully fetched',
      build: () {
        when(mockSearchTv.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSearchLoading(),
        TvSearchHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
        return OnQueryChanged(tQuery).props;
      },
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'should emit Error state when the searched data failed to fetch',
      build: () {
        when(mockSearchTv.execute(tQuery)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSearchLoading(),
        TvSearchError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
        return TvSearchLoading().props;
      },
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'should emit Empty state when the searched data is empty',
      build: () {
        when(mockSearchTv.execute(tQuery))
            .thenAnswer((_) async => const Right([]));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSearchLoading(),
        TvSearchEmpty(),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
      },
    );
  });
}
