import 'dart:convert';

import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tTvModel = TvModel(
    backdropPath: "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
    genreIds: [10763],
    id: 94722,
    originalName: "Tagesschau",
    overview:
        "German daily news program, the oldest still existing program on German television.",
    popularity: 3420.692,
    posterPath: "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
    name: "Tagesschau",
    voteAverage: 7.5,
    voteCount: 123,
  );
  final tTvResponseModel = const TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_on_the_air.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/jWXrQstj7p3Wl5MfYWY6IHqRpDb.jpg",
            "genre_ids": [10763],
            "id": 94722,
            "original_name": "Tagesschau",
            "overview":
                "German daily news program, the oldest still existing program on German television.",
            "popularity": 3420.692,
            "poster_path": "/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg",
            "name": "Tagesschau",
            "vote_average": 7.5,
            "vote_count": 123,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
