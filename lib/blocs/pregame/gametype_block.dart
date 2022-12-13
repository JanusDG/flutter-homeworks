import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/pregame/gametype_event.dart';
import 'package:flutter_concentration_game/blocs/pregame/gametype_state.dart';

class GameTypeBloc extends Bloc<GameTypeEvent, GameTypeState> {
  GameTypeBloc() : super(const GameTypeState(isTimeBound: true)) {
    on<SelectMovesGameTypeEvent>(
        (event, emit) => emit(GameTypeState(isTimeBound: false)));
    on<SelectTimeGameTypeEvent>(
        (event, emit) => emit(GameTypeState(isTimeBound: true)));
  }
}
