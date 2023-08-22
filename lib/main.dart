import 'package:about/about_page.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/utils.dart';
import 'package:ditonton/pages/home_tv_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:movie/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:movie/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:movie/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:movie/pages/movie_detail_page.dart';
import 'package:ditonton/pages/home_movie_page.dart';
import 'package:tv/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:tv/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:tv/pages/popular_tv_page.dart';
import 'package:movie/pages/popular_movies_page.dart';
import 'package:search/pages/movie_search_page.dart';
import 'package:movie/pages/top_rated_movies_page.dart';
import 'package:tv/pages/top_rated_tv_page.dart';
import 'package:tv/pages/tv_detail_page.dart';
import 'package:search/pages/tv_search_page.dart';
import 'package:ditonton/pages/watchlist_page.dart';
import 'package:search/bloc/movie_search/movie_search_bloc.dart';
import 'package:search/bloc/tv_search/tv_search_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieNowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviePopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviePopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistStatusBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecommendationsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvNowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvPopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvWatchlistStatusBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case HomeTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const HomeTvPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case PopularTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const PopularTvPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case TopRatedTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const TopRatedTvPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case MovieSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const MovieSearchPage());
            case TvSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const TvSearchPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
