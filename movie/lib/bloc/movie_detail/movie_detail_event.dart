import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {}

class OnFetchDetail extends MovieDetailEvent {
  final int id;

  OnFetchDetail(this.id);

  @override
  List<Object?> get props => [id];
}
