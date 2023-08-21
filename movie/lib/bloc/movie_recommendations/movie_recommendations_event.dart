import 'package:equatable/equatable.dart';

abstract class MovieRecommendationsEvent extends Equatable {}

class OnFetchRecommendations extends MovieRecommendationsEvent {
  final int id;

  OnFetchRecommendations(this.id);

  @override
  List<Object?> get props => [id];
}
