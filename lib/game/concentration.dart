import 'package:flutter_concentration_game/game/card.dart';
import 'package:logging/logging.dart';
import 'dart:io';

enum GameType { time, moves }

class Concentration {
  late final bool isTimeBound;
  late List<dynamic> cards;
  late final List<CardBrains> deck;
  int moveCounter = -1;
  bool timeOver = false;
  late final int pairsNumber;
  int _cardFlippedIndex = -1; // index of a card that is flipped, else -1
  late final Logger log;
  bool gameWon = false;
  bool gameLost = false;

  void initDeck(cardsu) {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    cards = List<dynamic>.from(cardsu);
    cards.shuffle();
    cards = cards.sublist(0, pairsNumber);
    var car = cards + cards;
    car.shuffle();
    List<CardBrains> deckMaker = [];
    for (var i = 0; i < car.length; i++) {
      deckMaker.add(CardBrains(car[i], i));
    }
    // deckMaker.shuffle();
    deck = deckMaker;
    log.info("Deck initted");
  }

  Concentration.timeBound(
      {required cards, required logger, this.pairsNumber = 2}) {
    isTimeBound = true;
    log = logger;
    initDeck(cards);
  }
  Concentration.movesMode(
      {required cards,
      required logger,
      this.pairsNumber = 2,
      this.moveCounter = 10}) {
    log = logger;
    isTimeBound = false;
    initDeck(cards);
  }

  String gameMode() => isTimeBound ? "Time" : "Moves";

  bool _checkIfMatched(int index) {
    if (_cardFlippedIndex != -1) {
      // if there is a one card that is flipped
      var flippedCard = deck[_cardFlippedIndex];
      var currentCard = deck[index];
      if (index != _cardFlippedIndex &&
          flippedCard.isFlippedUp &&
          flippedCard.isSame(currentCard)) {
        // if there is a flipped card with same content
        // sleep(const Duration(seconds: 2));
        currentCard.isMatched = true;

        currentCard.flip();
        flippedCard.isMatched = true;
        flippedCard.flip();
        _cardFlippedIndex = -1;
        return true;
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          currentCard.flip();
          flippedCard.flip();
        });
        _cardFlippedIndex = -1;
      }
    } else {
      _cardFlippedIndex = index;
    }
    return false;
  }

  bool _checkIfWin() {
    for (var card in deck) {
      if (card.isMatched == false) {
        return false;
      }
    }
    return true;
  }

  bool _checkIfLost() {
    return ((!isTimeBound && moveCounter == 0) ||
        (isTimeBound && timeOver == true));
  }

  void chooseCard(int index) {
    if (gameLost || gameWon) {
      return;
    }
    log.info("Flip started");
    var i = index;
    if (deck[i].isMatched || deck[i].isFlippedUp) {
      log.info("$i is ${deck[i].isFlippedUp}");
      return;
    }
    // flip a card
    deck[i].flip();
    log.info("you flipped: ${deck[i].content}");

    // check if card maches the other
    bool matched = _checkIfMatched(i);
    for (var card in deck) {
      // log.info(
      //     "index: ${card.index} content: ${card.content} state:${card.isFlippedUp ? "flipped" : "not flipped"},  matched:${card.isMatched ? "yes" : "no"}");
    }
    bool ifWon = false;
    if (matched) {
      log.info("matched!");
      // if matched, check if the game ended
      ifWon = _checkIfWin();
      if (ifWon) {
        log.info("u won!");
        gameWon = true;
      }
    }

    // end of turn result
    moveCounter--;
    bool lost = false;
    if (!ifWon) {
      lost = _checkIfLost();
    }
    if (lost) {
      log.info("u lost!");
      gameLost = true;
    }
  }
}
