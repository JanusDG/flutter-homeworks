import 'package:equatable/equatable.dart';

class PlayCardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlipPlayCardEvent extends PlayCardEvent {
  final int index;
  FlipPlayCardEvent(this.index);
}
