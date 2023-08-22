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
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/domain/usecases/get_movie_popular.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/domain/usecases/get_movie_top_rated.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/get_movie_watchlist.dart';
import 'package:core/domain/usecases/get_movie_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
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
import 'package:tv/provider/popular_tv_notifier.dart';
import 'package:tv/provider/top_rated_tv_notifier.dart';
import 'package:tv/provider/tv_detail_notifier.dart';
import 'package:tv/provider/tv_list_notifier.dart';
import 'package:tv/provider/watchlist_tv_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
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
  locator.registerFactory(
    () => TvListNotifier(
      getNowPlayingTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getTvWatchListStatus: locator(),
      saveTvWatchlist: locator(),
      removeTvWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvNotifier(
      getTopRatedTv: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSearchBloc(locator()),
  );
  locator.registerFactory(
    () => WatchlistTvNotifier(
      getWatchlistTv: locator(),
    ),
  );

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
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

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
