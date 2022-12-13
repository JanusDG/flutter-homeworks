import 'package:equatable/equatable.dart';
import 'package:flutter_concentration_game/game/concentration.dart';

class GameTypeState extends Equatable {
  final bool isTimeBound;

  const GameTypeState({required this.isTimeBound});

  @override
  List<Object?> get props => [isTimeBound];
}
