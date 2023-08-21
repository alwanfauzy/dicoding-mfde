import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_event.dart';
import 'package:movie/bloc/movie_watchlist/movie_watchlist_state.dart';
import 'package:core/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MovieWatchlistBloc>().add(OnFetchWatchlist()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Future.microtask(
      () => context.read<MovieWatchlistBloc>().add(OnFetchWatchlist()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<MovieWatchlistBloc, MovieWatchlistState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MovieWatchlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieWatchlistHasData) {
            var movies = state.result;
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie);
              },
              itemCount: movies.length,
            );
          } else if (state is MovieWatchlistError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
