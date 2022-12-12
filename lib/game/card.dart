// import 'package:flutter/widgets.dart';

class PlayCard {
  bool isFlippedUp = false;
  bool isMatched = false;
  late final dynamic content;
  late final int index;

  PlayCard(this.content, this.index);

  void flip() {
    isFlippedUp = !isFlippedUp;
  }

  bool isSame(PlayCard otherCard) =>this.content == otherCard.content;
}