import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/concentration/concentration_event.dart';
import 'package:flutter_concentration_game/blocs/concentration/concentration_state.dart';

import '../../game/concentration.dart';

class ConcentrationTimeBloc
    extends Bloc<ConcentrationEvent, ConcentrationState> {
  ConcentrationTimeBloc(val)
      : super(ConcentrationState(
            game: Concentration.movesMode(cards: [], logger: null))) {
    on<CardClicked>((event, emit) {
      state.game.chooseCard(val);
      emit(ConcentrationState(game: state.game));
    });
    // on<SelectTimeConcentrationEvent>(
    //     (event, emit) => emit(ConcentrationState(isTimeBound: true)));
  }
}

class ConcentrationMoveBloc
    extends Bloc<ConcentrationEvent, ConcentrationState> {
  ConcentrationMoveBloc(val)
      : super(ConcentrationState(
            game: Concentration.movesMode(cards: [], logger: null))) {
    on<CardClicked>((event, emit) {
      state.game.chooseCard(val);
      emit(ConcentrationState(game: state.game));
    });
    // on<SelectTimeConcentrationEvent>(
    //     (event, emit) => emit(ConcentrationState(isTimeBound: true)));
  }
}
