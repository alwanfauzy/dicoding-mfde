import 'package:equatable/equatable.dart';

abstract class TvSearchEvent extends Equatable {}

class OnQueryChanged extends TvSearchEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
