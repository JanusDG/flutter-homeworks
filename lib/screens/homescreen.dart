import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/screens/pregamescreen.dart';

import 'package:flutter_concentration_game/blocs/gametype/gametype_block.dart';

import 'gamescreen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('New Game'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (_) => GameTypeBloc(),
                            child: const PreGameScreen(),
                          )),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Continue'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: const Text('Options'),
              onPressed: () {},
            ),
          ],
        ),
      ));

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();
}
