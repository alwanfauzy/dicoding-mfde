import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv/bloc/tv_recommendations/tv_recommendations_state.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_event.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_event.dart';
import 'package:tv/bloc/tv_watchlist_status/movie_watchlist_status_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = TV_DETAIL_PAGE_ROUTE;

  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(OnFetchDetail(widget.id));
      context.read<TvWatchlistBloc>().add(OnFetchWatchlist());
      context
          .read<TvWatchlistStatusBloc>()
          .add(OnFetchWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            final tv = state.result;
            return SafeArea(
              child: TvDetailContent(tv),
            );
          } else if (state is TvDetailError) {
            return Text(state.message);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class TvDetailContent extends StatelessWidget {
  final TvDetail tv;

  const TvDetailContent(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            _watchlistButton(context),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              _showSeasonsInfo(
                                  tv.numberOfSeasons, tv.numberOfEpisodes),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationsBloc,
                                TvRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvRecommendationsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationsError) {
                                  return Text(state.message);
                                } else if (state is TvRecommendationsHasData) {
                                  List<Tv> recommendations = state.result;
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            _seasons(tv.seasons),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showSeasonsInfo(int seasonCount, int episodeCount) =>
      "Season Count: $seasonCount\nEpisode Count: $episodeCount";

  Widget _seasons(List<TvSeason> seasons) {
    return Column(
      children: seasons
          .map((season) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${season.seasonNumber} (${season.name})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text("Air Date: ${season.airDate ?? "-"}"),
                  Text("Episodes: ${season.episodeCount}"),
                  const Divider(),
                ],
              ))
          .toList(),
    );
  }

  Widget _watchlistButton(BuildContext context) {
    return BlocConsumer<TvWatchlistStatusBloc, TvWatchlistStatusState>(
        listener: (context, state) {
      if (state is TvWatchlistStatusIsAdded && state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message!)),
        );
      } else if (state is TvWatchlistStatusError) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(state.message),
            );
          },
        );
      }
    }, builder: (context, state) {
      return ElevatedButton(
        onPressed: () async {
          if (state is TvWatchlistStatusIsAdded) {
            context.read<TvWatchlistStatusBloc>().add(
                state.isAdded ? OnRemoveWatchlist(tv) : OnSaveWatchlist(tv));
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state is TvWatchlistStatusIsAdded)
              state.isAdded ? const Icon(Icons.check) : const Icon(Icons.add),
            const Text('Watchlist'),
          ],
        ),
      );
    });
  }
}
