import 'package:flutter_concentration_game/game/card.dart';
import 'package:logging/logging.dart';

class Concentration {
  late bool isTimeBound; 
  late List<dynamic> cards; 
  late final List<PlayCard> deck; 
  int moveCounter = -1; 
  bool timeOver=false; 
  late final int pairsNumber;
  int _cardFlippedIndex = -1; // index of a card that is flipped, else -1
  final log = Logger('Concentration');
  

  void initDeck(){
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
    cards.shuffle();
    cards = cards.sublist(0, pairsNumber);
    List<PlayCard> deckMaker=[];
    for(var i=0;i<cards.length*2;i++){
        deckMaker.add(PlayCard(cards[i%cards.length], i+1));
    }
    deckMaker.shuffle();
    this.deck = deckMaker;
  }

  Concentration.timeBound({required this.cards,
                           this.pairsNumber=2}){
    isTimeBound = true;
    this.initDeck();
    
  }
  Concentration.movesMode({required this.cards,
                          this.pairsNumber=2,
                          this.moveCounter=10}){
    isTimeBound = false;
    this.initDeck();
    
  }

  String gameMode()=>isTimeBound? "Time" : "Moves";
          
  bool _checkIfMatched(int index){
    if (_cardFlippedIndex != -1){
      
      // if there is a one card that is flipped
      var flippedCard = deck[_cardFlippedIndex];
      var currentCard = deck[index];
      if (index != _cardFlippedIndex && 
          flippedCard.isFlippedUp && 
          flippedCard.isSame(currentCard)){
            // if there is a flipped card with same content
            currentCard.isMatched = true;
            currentCard.flip();
            flippedCard.isMatched = true;
            flippedCard.flip();
            _cardFlippedIndex = -1;
            return true;
      }else{
            flippedCard.flip();
            currentCard.flip();
            this._cardFlippedIndex = -1;
      }
    }else{
      this._cardFlippedIndex = index;
    }
    return false;
  }

  bool _checkIfWin(){
    for (var card in this.deck) {
      if (card.isMatched == false){
        return false;
      }
    }
    return true;
  }

  bool _checkIfLost(){
    return ((!this.isTimeBound && this.moveCounter == 0) || (this.isTimeBound && this.timeOver == true));
  }

  void chooseCard(int index){
    var i = index-1;
    if (this.deck[i].isMatched || this.deck[i].isFlippedUp){
      return;
    }
    // flip a card
    this.deck[i].flip();
    log.info("you flipped: ${this.deck[i].content}");

    
    // check if card maches the other
    bool matched = this._checkIfMatched(i);
    for (var card in this.deck) {
      log.info("index: ${card.index} content: ${card.content} state:${card.isFlippedUp?"flipped":"not flipped"},  matched:${card.isMatched?"yes":"no"}");
    }
    bool ifWon = false;
    if (matched){
      log.info("matched!");
      // if matched, check if the game ended
      ifWon = this._checkIfWin();
      if (ifWon){
        log.info("u won!");
      }
    }
    

    // end of turn result
    this.moveCounter--;
    bool lost = false;
    if (!ifWon){
      lost = this._checkIfLost();
    }
    if (lost){
        log.info("u lost!");
    }

    
    
  }

}