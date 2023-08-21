import 'package:equatable/equatable.dart';

abstract class MoviePopularEvent extends Equatable {}

class OnFetchPopular extends MoviePopularEvent {
  @override
  List<Object?> get props => [];
}
