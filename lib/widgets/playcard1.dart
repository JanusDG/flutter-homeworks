import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_concentration_game/blocs/playcard/playcard_block.dart';
import 'package:flutter_concentration_game/game/card.dart';

import '../blocs/gametype/gametype_block.dart';
import '../blocs/gametype/gametype_state.dart';
// import 'package:flutter_concentration_game/blocs/playcard copy/playcard_block.dart';
import '../blocs/playcard/playcard_event.dart';

class PlayCard extends StatelessWidget {
  PlayCard({Key? key, required this.title, required this.brains})
      : super(key: key);

  final String title;
  final CardBrains brains;

  late bool _flipXAxis = true;

  void initState() {
    // super.initState();
    _flipXAxis = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameTypeBloc, GameTypeState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints.tight(Size.square(200.0)),
          child: _buildFlipAnimation(context),
        );
      },
    );
  }

  Widget _buildFlipAnimation(context) {
    int index = 1;
    return GestureDetector(
      onTap: () {
        () {
          context.read<PlayCardBloc>().add(FlipPlayCardEvent(index));
          brains.flip();
        };
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) {
          if (widget != null) {
            return Stack(children: [widget, ...list]);
          } else {
            // TODO FIX THIS
            return Stack(children: const []);
          }
        },
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: brains.isFlippedUp ? _buildRear() : _buildFront(),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(brains.isFlippedUp) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: const ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: Image.asset('assets/images/nothing.png'),
      child: const Padding(
        padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: const ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: Image.asset(brains.content),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child:
              Center(child: Text("Flutter", style: TextStyle(fontSize: 50.0))),
        ),
      ),
    );
  }

  Widget __buildLayout(
      {Key? key, Widget? child, dynamic? faceName, Color? backgroundColor}) {
    return Container(
        key: key,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: backgroundColor,
        ),
        child: faceName);
  }
}
