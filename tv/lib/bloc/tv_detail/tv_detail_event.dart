import 'package:equatable/equatable.dart';

abstract class TvDetailEvent extends Equatable {}

class OnFetchDetail extends TvDetailEvent {
  final int id;

  OnFetchDetail(this.id);

  @override
  List<Object?> get props => [id];
}
