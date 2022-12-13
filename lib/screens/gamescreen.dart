import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
// import 'package:flutter_concentration_game/blocs/pregame/index.dart';

// import 'dart:async';
// import 'package:quiver/async.dart';

const List<String> gameModeDropDown = <String>['Time', 'Turns'];

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Duration _duration = const Duration(hours: 0, minutes: 0);
  String dropdownValue = gameModeDropDown.first;
  int _currentValue = 3;

  bool f = true;
  // bool f = false;

  void _handleDropDownGameMod(String? value) {
    setState(() {
      dropdownValue = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: _handleDropDownGameMod,
                        items: gameModeDropDown
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (dropdownValue == "Time")
                        Text(
                            "Current value: ${_duration.inHours}:${_duration.inMinutes.remainder(60)}"),
                      if (dropdownValue == "Turns")
                        Text('Current value: $_currentValue'),
                    ],
                  ),
                ),
                if (dropdownValue == "Time")
                  SizedBox(
                    height: (MediaQuery.of(context).size.width) / 2,
                    width: (MediaQuery.of(context).size.width) / 2,
                    child: DurationPicker(
                      duration: _duration,
                      onChange: (val) {
                        setState(() => _duration = val);
                      },
                      snapToMins: 5.0,
                    ),
                  ),
                if (dropdownValue == "Turns")
                  SizedBox(
                    height: (MediaQuery.of(context).size.width) / 2,
                    width: (MediaQuery.of(context).size.width) / 2,
                    child: NumberPicker(
                      value: _currentValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentValue = value),
                    ),
                  ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.purple,
              ),
              onPressed: () {},
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
