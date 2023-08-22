import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvSearchLoading extends TvSearchState {}

class TvSearchEmpty extends TvSearchState {}

class TvSearchError extends TvSearchState {
  final String message;

  TvSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvSearchHasData extends TvSearchState {
  final List<Tv> result;

  TvSearchHasData(this.result);

  @override
  List<Object?> get props => [result];
}
