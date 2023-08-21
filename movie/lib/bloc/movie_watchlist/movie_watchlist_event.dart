import 'package:equatable/equatable.dart';

abstract class MovieWatchlistEvent extends Equatable {}

class OnFetchWatchlist extends MovieWatchlistEvent {
  @override
  List<Object?> get props => [];
}
