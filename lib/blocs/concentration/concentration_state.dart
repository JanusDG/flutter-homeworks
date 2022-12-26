import 'package:equatable/equatable.dart';
import 'package:flutter_concentration_game/game/concentration.dart';

class ConcentrationState extends Equatable {
  final Concentration game;

  const ConcentrationState({required this.game});

  @override
  List<Object?> get props => [game];
}
