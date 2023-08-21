import 'package:equatable/equatable.dart';

abstract class MovieTopRatedEvent extends Equatable {}

class OnFetchTopRated extends MovieTopRatedEvent {
  @override
  List<Object?> get props => [];
}
