import 'package:equatable/equatable.dart';

class GameTypeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectTimeGameTypeEvent extends GameTypeEvent {}

class SelectMovesGameTypeEvent extends GameTypeEvent {}
