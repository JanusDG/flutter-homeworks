import 'package:equatable/equatable.dart';
import 'package:flutter_concentration_game/game/concentration.dart';

class GameTypeState extends Equatable {
  final bool isTimeBound;
  final Duration timeDuration = const Duration();
  final int moveCounter = 0;
  // final Concentration game;

  const GameTypeState({required this.isTimeBound, timeDuration, moveConter});

  @override
  List<Object?> get props => [isTimeBound];
}
