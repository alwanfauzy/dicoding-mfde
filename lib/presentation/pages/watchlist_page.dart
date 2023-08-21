import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: 'Movies'),
    Tab(text: 'TV'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(tabs: _tabs),
        ),
        body: TabBarView(children: [
          WatchlistMoviesPage(),
          WatchlistTvPage(),
        ]),
      ),
    );
  }
}
