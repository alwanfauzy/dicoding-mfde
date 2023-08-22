import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class TvRecommendationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvRecommendationsLoading extends TvRecommendationsState {}

class TvRecommendationsEmpty extends TvRecommendationsState {}

class TvRecommendationsError extends TvRecommendationsState {
  final String message;

  TvRecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvRecommendationsHasData extends TvRecommendationsState {
  final List<Tv> result;

  TvRecommendationsHasData(this.result);

  @override
  List<Object?> get props => [result];
}
