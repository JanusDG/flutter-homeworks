import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/gametype/gametype_event.dart';
import 'package:flutter_concentration_game/blocs/gametype/gametype_state.dart';

class GameTypeBloc extends Bloc<GameTypeEvent, GameTypeState> {
  GameTypeBloc() : super(const GameTypeState(isTimeBound: false)) {
    on<ChangeGameTypeEvent>(
        (event, emit) => emit(GameTypeState(isTimeBound: !state.isTimeBound)));
  }
}
