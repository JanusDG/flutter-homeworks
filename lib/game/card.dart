// import 'package:flutter/widgets.dart';

class CardBrains {
  bool isFlippedUp = false;
  bool isMatched = false;
  late final dynamic content;
  late final int index;

  CardBrains(this.content, this.index);

  void flip() {
    isFlippedUp = !isFlippedUp;
  }

  bool isSame(CardBrains otherCard) => content == otherCard.content;
}
