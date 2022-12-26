import 'dart:math';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/gametype/gametype_block.dart';
import 'package:flutter_concentration_game/game/card.dart';
import 'package:flutter_concentration_game/widgets/playcard.dart';

import '../blocs/gametype/gametype_state.dart';
import '../blocs/playcard/playcard_block.dart';
import '../blocs/playcard/playcard_state.dart';
import '../game/concentration.dart';
import 'package:logging/logging.dart';

const cardContents = [
  "assets/images/apple.png",
  // "assets/images/nothing.png",
  "assets/images/cheese.png",
  "assets/images/chili.png",
  "assets/images/cherries.png",
  "assets/images/grapes.png",
  "assets/images/lemon.png",
  "assets/images/pineapple.png",
  "assets/images/raspberry.png",
  "assets/images/strawberry.png",
  "assets/images/tomato.png",
];

class GameScreen extends StatefulWidget {
  GameScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  // final bool isTimeBound;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late bool _flipXAxis;
  // late  cards;
  late List<TableRow> rowCards;
  // late Concentration gameBrains;

  // @override
  void init(isTimeBound, gameBrains) {
    // final log = Logger('Game');
    // Logger.root.level = Level.INFO;
    // Logger.root.onRecord.listen((record) {
    //   print('${record.level.name}: ${record.time}: ${record.message}');
    // });
    gameBrains.log.info("Game Started");
    // super.initState();
    _flipXAxis = true;

    // gameBrains = isTimeBound
    //     ? Concentration.timeBound(cards: cardContents, logger: log)
    //     : Concentration.movesMode(cards: cardContents, logger: log);
    List<PlayCard> cards = [];
    for (var element in gameBrains.deck) {
      cards.add(PlayCard(title: "${element.index}", brains: element));
      // gameBrains.log.info("${element.index}");
    }
    const int maxItemsInRow = 4;
    late int rowN;
    late int colN;
    double size = cards.length.roundToDouble();
    // for (int k = maxItemsInRow; k > 0; k--) {
    //   if (size % k == 0) {
    //     rowN = k;
    //     break;
    //   }
    // }
    rowN = maxItemsInRow;
    int t = (size / rowN).round();
    if (t * rowN < size) {
      colN = t + 1;
    } else {
      colN = t;
    }
    // if (cards.length / 2 < maxItemsInRow) {
    //   rowN = (cards.length / 2).round();
    //   colN = 2;
    // } else {
    //   rowN = maxItemsInRow;
    //   colN = (cards.length / rowN).round() + 1;
    // }

    late List<TableRow> rows = [];

    Queue<PlayCard> queue = Queue.from(cards);
    for (int j = 0; j < colN; j++) {
      List<PlayCard> l = [];
      for (int i = 0; i < rowN; i++) {
        if (queue.isNotEmpty) {
          l.add(queue.removeFirst());
        } else {
          l.add(PlayCard(
              title: "blank",
              brains: CardBrains("assets/images/nothing.png", -2)));
        }
      }
      rows.add(TableRow(children: l));
    }
    rowCards = rows;
  }

  @override
  Widget build(BuildContext context) {
    bool isTimeBound =
        context.select((GameTypeBloc gt) => gt.state.isTimeBound);
    Concentration gameBrains =
        context.select((PlayCardBloc pc) => pc.state.game);
    init(isTimeBound, gameBrains);
    // (context) => PlayCardBloc(gameBrains);
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<GameTypeBloc, GameTypeState>(
          builder: (context, state) {
            return Text(state.isTimeBound ? "Time" : "Moves");
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: RotatedBox(
              quarterTurns: _flipXAxis ? 0 : 1,
              child: const Icon(Icons.flip),
            ),
            onPressed: _changeRotationAxis,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              child: Center(
                child: BlocProvider.value(
                  value: BlocProvider.of<PlayCardBloc>(context),
                  child: Table(children: rowCards),
                ),
              ),
            ),
            BlocBuilder<PlayCardBloc, PlayCardState>(
              builder: (context, state) {
                if (state.game.gameLost || state.game.gameWon) {
                  return TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("That's it folks!"),
                        content: Text(
                            state.game.gameLost ? "you've lost" : "you've won"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Return'),
                            child: const Text('Return'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Show results'),
                  );
                } else {
                  return const Text("");
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _changeRotationAxis() {
    setState(() {
      _flipXAxis = !_flipXAxis;
    });
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}
