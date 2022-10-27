class Card {
  bool isFlippedUp = false;
  bool isMatched = false;
  late String content;
  late int index;
  bool ifEqual = false;

  void flip() {
    isFlippedUp = !isFlippedUp;
  } 
}