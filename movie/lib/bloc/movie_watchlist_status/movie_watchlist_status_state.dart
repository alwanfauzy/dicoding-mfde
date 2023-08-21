import 'package:equatable/equatable.dart';

abstract class MovieWatchlistStatusState extends Equatable {}

class MovieWatchlistStatusEmpty extends MovieWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistStatusIsAdded extends MovieWatchlistStatusState {
  final bool isAdded;

  MovieWatchlistStatusIsAdded(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class MovieWatchlistStatusMessage extends MovieWatchlistStatusState {
  final String message;

  MovieWatchlistStatusMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieWatchlistStatusError extends MovieWatchlistStatusState {
  final String message;

  MovieWatchlistStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
