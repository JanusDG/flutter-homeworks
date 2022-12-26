import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/playcard/playcard_event.dart';
import 'package:flutter_concentration_game/blocs/playcard/playcard_state.dart';
import 'package:flutter_concentration_game/game/concentration.dart';

class PlayCardBloc extends Bloc<PlayCardEvent, PlayCardState> {
  // int index;

  PlayCardBloc(Concentration game)
      : super(PlayCardState(isFlippedUp: false, game: game)) {
    on<FlipPlayCardEvent>((event, emit) {
      state.game.chooseCard(event.index);
      state.game.log.info("Flipped ${event.index}");
      emit(PlayCardState(isFlippedUp: !state.isFlippedUp, game: state.game));
    });

    // on<SelectTimePlayCardEvent>(
    //     (event, emit) => emit(PlaycardState(isTimeBound: true)));
  }
}
