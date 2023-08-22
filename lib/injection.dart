import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_movie_now_playing.dart';
import 'package:core/domain/usecases/get_movie_popular.dart';
import 'package:core/domain/usecases/get_movie_top_rated.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_now_playing.dart';
import 'package:core/domain/usecases/get_tv_popular.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_movie_watchlist.dart';
import 'package:core/domain/usecases/get_movie_watchlist_status.dart';
import 'package:core/domain/usecases/get_tv_top_rated.dart';
import 'package:core/domain/usecases/get_tv_watchlist.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_tv_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:core/domain/usecases/search_movie.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:movie/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:search/bloc/movie_search/movie_search_bloc.dart';
import 'package:search/bloc/tv_search/tv_search_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:tv/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:tv/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => MovieRecommendationsBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(locator()));
  locator.registerFactory(() => MovieSearchBloc(locator()));
  locator.registerFactory(() => MoviePopularBloc(locator()));
  locator.registerFactory(() => MovieTopRatedBloc(locator()));
  locator.registerFactory(() => MovieNowPlayingBloc(locator()));
  locator.registerFactory(() => MovieWatchlistBloc(locator()));
  locator.registerFactory(() => MovieWatchlistStatusBloc(
        locator(),
        locator(),
        locator(),
      ));
  locator.registerFactory(() => TvRecommendationsBloc(locator()));
  locator.registerFactory(() => TvDetailBloc(locator()));
  locator.registerFactory(() => TvSearchBloc(locator()));
  locator.registerFactory(() => TvPopularBloc(locator()));
  locator.registerFactory(() => TvTopRatedBloc(locator()));
  locator.registerFactory(() => TvNowPlayingBloc(locator()));
  locator.registerFactory(() => TvWatchlistBloc(locator()));
  locator.registerFactory(() => TvWatchlistStatusBloc(
        locator(),
        locator(),
        locator(),
      ));

  // use case
  locator.registerLazySingleton(() => GetMovieNowPlaying(locator()));
  locator.registerLazySingleton(() => GetMoviePopular(locator()));
  locator.registerLazySingleton(() => GetMovieTopRated(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovie(locator()));
  locator.registerLazySingleton(() => GetMovieWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvNowPlaying(locator()));
  locator.registerLazySingleton(() => GetTvPopular(locator()));
  locator.registerLazySingleton(() => GetTvTopRated(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetTvWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvWatchlist(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
