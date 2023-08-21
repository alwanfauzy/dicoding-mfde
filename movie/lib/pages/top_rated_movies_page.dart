import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_event.dart';
import 'package:movie/bloc/movie_top_rated/movie_top_rated_state.dart';
import 'package:core/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MovieTopRatedBloc>().add(OnFetchTopRated()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<MovieTopRatedBloc, MovieTopRatedState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is MovieTopRatedLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieTopRatedHasData) {
              var movies = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(movie);
                },
                itemCount: movies.length,
              );
            } else if (state is MovieTopRatedError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
