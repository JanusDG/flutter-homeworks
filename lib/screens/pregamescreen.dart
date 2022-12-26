// ignore_for_file: unused_import
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/gametype/gametype_state.dart';
import 'package:logging/logging.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_concentration_game/blocs/gametype/index.dart';
import 'package:flutter_concentration_game/blocs/playcard/index.dart';

import '../blocs/playcard/playcard_block.dart';
import '../blocs/playcard/playcard_event.dart';
import '../blocs/playcard/playcard_state.dart';
import '../blocs/gametype/gametype_block.dart';
import '../blocs/gametype/gametype_event.dart';
import '../game/concentration.dart';
import 'gamescreen.dart';

const List<String> gameModeDropDown = <String>['Time', 'Turns'];

class PreGameScreen extends StatefulWidget {
  const PreGameScreen({super.key});
  // final bool isTimeBound;

  @override
  State<PreGameScreen> createState() => PreGameScreenState();
}

class PreGameScreenState extends State<PreGameScreen> {
  Duration _duration = const Duration(hours: 0, minutes: 0);
  String dropdownValue = gameModeDropDown.first;
  int _currentValue = 4;
  int _currentValue1 = 4;

  bool f = true;

  @override
  Widget build(BuildContext context) {
    bool isTimeBound =
        context.select((GameTypeBloc gt) => gt.state.isTimeBound);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.width) / 2,
                  width: (MediaQuery.of(context).size.width) / 2,
                  child: Column(
                    children: [
                      const Text('Select Game Type: '),
                      ElevatedButton(
                        child: BlocBuilder<GameTypeBloc, GameTypeState>(
                          builder: (context, gametype) => Center(
                              child: Column(children: [
                            if (gametype.isTimeBound == true)
                              const Text("Time"),
                            if (gametype.isTimeBound == false)
                              const Text('Moves'),
                          ])),
                        ),
                        onPressed: () => context
                            .read<GameTypeBloc>()
                            .add(ChangeGameTypeEvent()),
                      ),
                      BlocBuilder<GameTypeBloc, GameTypeState>(
                        builder: (context, state) {
                          if (state.isTimeBound == false) {
                            return Text('Current Moves: $_currentValue');
                          } else {
                            return Text(
                                "Current value: ${_duration.inHours}:${_duration.inMinutes.remainder(60)}");
                          }
                        },
                      ),
                      Text('Select Number of pairs: $_currentValue1'),
                      Slider(
                        value: _currentValue1.toDouble(),
                        max: 6,
                        divisions: 6,
                        label: _currentValue1.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentValue1 = value.round();
                          });
                        },
                      ),
                      // NumberPicker(
                      //   value: _currentValue1,
                      //   minValue: 4,
                      //   maxValue: 30,
                      //   onChanged: (value) =>
                      //       setState(() => _currentValue1 = value),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.width) / 2,
                  width: (MediaQuery.of(context).size.width) / 2,
                  child: BlocBuilder<GameTypeBloc, GameTypeState>(
                    builder: (context, state) {
                      if (state.isTimeBound == true) {
                        return DurationPicker(
                          duration: _duration,
                          onChange: (val) {
                            setState(() => _duration = val);
                          },
                          snapToMins: 5.0,
                        );
                      } else {
                        return NumberPicker(
                          value: _currentValue,
                          minValue: 2,
                          maxValue: 30,
                          onChanged: (value) =>
                              setState(() => _currentValue = value),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (newContext) {
                  final log = Logger('Game');
                  Logger.root.level = Level.INFO;
                  Logger.root.onRecord.listen((record) {
                    print(
                        '${record.level.name}: ${record.time}: ${record.message}');
                  });

                  var gameBrains = isTimeBound
                      ? Concentration.timeBound(
                          cards: cardContents,
                          logger: log,
                          pairsNumber: _currentValue1)
                      : Concentration.movesMode(
                          cards: cardContents,
                          logger: log,
                          moveCounter: _currentValue,
                          pairsNumber: _currentValue1);
                  if (isTimeBound) {
                    Future.delayed(_duration, () {
                      gameBrains.timeOver = true;
                    });
                  }
                  return BlocProvider.value(
                    value: BlocProvider.of<GameTypeBloc>(context),
                    child: BlocProvider(
                      create: (context) => PlayCardBloc(gameBrains),
                      // (context) => PlayCardBloc();
                      child: GameScreen(title: 'Game'),
                    ),
                  );
                }));
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
