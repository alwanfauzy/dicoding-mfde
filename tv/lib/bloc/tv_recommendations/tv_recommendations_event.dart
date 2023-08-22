import 'package:equatable/equatable.dart';

abstract class TvRecommendationsEvent extends Equatable {}

class OnFetchRecommendations extends TvRecommendationsEvent {
  final int id;

  OnFetchRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}
