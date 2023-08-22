import 'package:equatable/equatable.dart';

abstract class TvNowPlayingEvent extends Equatable {}

class OnFetchNowPlaying extends TvNowPlayingEvent {
  @override
  List<Object?> get props => [];
}
