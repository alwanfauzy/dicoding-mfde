import 'package:equatable/equatable.dart';

abstract class MovieWatchlistStatusState extends Equatable {}

class MovieWatchlistStatusEmpty extends MovieWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistStatusIsAdded extends MovieWatchlistStatusState {
  final bool isAdded;
  final String? message;

  MovieWatchlistStatusIsAdded({required this.isAdded, this.message});

  @override
  List<Object?> get props => [isAdded];
}

class MovieWatchlistStatusError extends MovieWatchlistStatusState {
  final String message;

  MovieWatchlistStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
