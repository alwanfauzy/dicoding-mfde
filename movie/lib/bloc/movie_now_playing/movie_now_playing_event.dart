import 'package:equatable/equatable.dart';

abstract class MovieNowPlayingEvent extends Equatable {}

class OnFetchNowPlaying extends MovieNowPlayingEvent {
  @override
  List<Object?> get props => [];
}
