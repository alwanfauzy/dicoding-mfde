import 'package:core/utils/utils.dart';
import 'package:core/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_event.dart';
import 'package:tv/bloc/tv_watchlist/tv_watchlist_state.dart';

class WatchlistTvPage extends StatefulWidget {
  const WatchlistTvPage({super.key});

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvWatchlistBloc>().add(OnFetchWatchlist()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<TvWatchlistBloc>().add(OnFetchWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TvWatchlistBloc, TvWatchlistState>(
        builder: (context, state) {
          if (state is TvWatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvWatchlistHasData) {
            var tvs = state.result;

            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = tvs[index];
                return TvCard(tv);
              },
              itemCount: tvs.length,
            );
          } else if (state is TvWatchlistError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
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
