import 'package:equatable/equatable.dart';

abstract class TvWatchlistEvent extends Equatable {}

class OnFetchWatchlist extends TvWatchlistEvent {
  @override
  List<Object?> get props => [];
}
