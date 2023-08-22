import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/get_tv_popular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvPopular usecase;
  late MockTvRepository mockTvRpository;

  setUp(() {
    mockTvRpository = MockTvRepository();
    usecase = GetTvPopular(mockTvRpository);
  });

  group('GetPopularTv Tests', () {
    group('execute', () {
      test(
          'should get list of tv from the repository when execute function is called',
          () async {
        // arrange
        when(mockTvRpository.getPopularTv())
            .thenAnswer((_) async => Right(testTvList));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(testTvList));
      });
    });
  });
}
