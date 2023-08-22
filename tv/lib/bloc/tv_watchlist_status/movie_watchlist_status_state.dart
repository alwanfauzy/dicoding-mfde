import 'package:equatable/equatable.dart';

abstract class TvWatchlistStatusState extends Equatable {}

class TvWatchlistStatusEmpty extends TvWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class TvWatchlistStatusIsAdded extends TvWatchlistStatusState {
  final bool isAdded;
  final String? message;

  TvWatchlistStatusIsAdded({required this.isAdded, this.message});

  @override
  List<Object?> get props => [isAdded];
}

class TvWatchlistStatusError extends TvWatchlistStatusState {
  final String message;

  TvWatchlistStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
