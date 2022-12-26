import 'package:equatable/equatable.dart';
import 'package:flutter_concentration_game/game/concentration.dart';

class PlayCardState extends Equatable {
  final bool isFlippedUp;
  final Concentration game;

  const PlayCardState({required this.isFlippedUp, required this.game});

  @override
  List<Object?> get props => [isFlippedUp, game];
}
