// ignore_for_file: unnecessary_this, unnecessary_breaks

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Blackjack',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 34, 34)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Player user = Player();
  Player dealer = Player();
  Player userSplit = Player();
  Deck deck = Deck();
  var current = Card1(1, "", "", 1);
  int currentCard = 0;
  double stack = (100.00);
  double bet = 10.0;

  bool gameStarted = false;
  bool gameEnded = false;

  int gameStatus = 0;
  int gameStatus2 = 0;
  bool justDealt = false;

  bool doubleOption = false;
  bool doubleTaken = false;
  bool splitOption = false;
  bool splitHand = false;
  bool splitInProg = false;
  bool splitResult = false;

  void deal() {
    if (!gameStarted) {
      print("Dealt");
      //bet = _CupertinoSliderExampleState()._currentSliderValue;
      print("${bet}");
      stack -= bet;
      user.addCard(deck.getCard());
      dealer.addCard(deck.getCard());
      user.addCard(deck.getCard());
      dealer.addCard(deck.getCard());
      if (user.getSum() == 21) {
        gameStatus = 5;
        gameEnded = true;
        justDealt = false;
      } else if (dealer.getSum() == 21) {
        gameEnded = true;
        gameStatus = 6;
        justDealt = false;
      }
      if (stack >= bet) {
        //stack -= bet;
        //bet = (bet*2.0);

        doubleOption = true;
        if (user._cards.elementAt(0).getValue() ==
            user._cards.elementAt(1).getValue()) {
          splitOption = true;
        }
      }
      //gameEnded = false;
      gameStarted = true;
      justDealt = true;
      notifyListeners();
    }
  }

  void doubleBet() {
    if (gameStarted && !gameEnded) {
      doubleOption = false;
      splitOption = false;
      doubleTaken = true;
      stack -= bet;
      bet = bet * 2.0;

      user.addCard(deck.getCard());
      if (user.getSum() == 21) {
        gameStatus = 1;
        justDealt = false;
        gameEnded = true;
      } else if (user.getSum() > 21) {
        gameEnded = true;
        justDealt = false;
        gameStatus = 3;
      } else {
        stand();
      }
    }
    notifyListeners();
  }

  void split() {
    if (gameStarted && !gameEnded) {
      doubleOption = false;
      splitOption = false;

      stack -= bet;
      //bet = bet*2.0;
      splitInProg = true;
      splitHand = true;
      gameStatus = 8;

      Card1 temp = user.pullCard();
      userSplit.addCard(temp);
      userSplit.addCard(deck.getCard());

      if (userSplit.getSum() == 21) {
        gameStatus2 = 1;
        //justDealt = false;
        gameEnded = true;
      }
    }
    notifyListeners();
  }

  void switchHands() {
    splitHand = false;
    gameEnded = false;
    user.addCard(deck.getCard());

    gameStatus = 9;
    //gameStatus2 = 0;

    if (user.getSum() == 21) {
      gameStatus = 1;
      justDealt = false;
      gameEnded = true;
    }
  }

  // Function for hitting (getting another card) - to be implemented later
  void hit() {
    // Implement logic for adding a card to the user's hand
    if (gameStarted && !gameEnded) {
      doubleOption = false;
      splitOption = false;
      if (splitHand) {
        userSplit.addCard(deck.getCard());
        if (userSplit.getSum() == 21) {
          gameStatus2 = 1;
          //switchHands();
          justDealt = false;
          gameEnded = true;
        } else if (userSplit.getSum() > 21) {
          gameEnded = true;
          //switchHands();
          justDealt = false;
          gameStatus2 = 3;
        }
      } else {
        user.addCard(deck.getCard());
        if (user.getSum() == 21) {
          gameStatus = 1;
          justDealt = false;
          gameEnded = true;
        } else if (user.getSum() > 21) {
          gameEnded = true;
          justDealt = false;
          gameStatus = 3;
        }
      }
    }
    notifyListeners();
  }

  void stand() {
    if (gameStarted && !gameEnded) {
      doubleOption = false;
      splitOption = false;
      if (!splitHand && !splitInProg) {
        //normal hand
        while (dealer.getSum() <= 16) {
          dealer.addCard(deck.getCard());
        }
        if (dealer.getSum() == 21) {
          gameStatus = 2;
        } else if (dealer.getSum() > 21) {
          gameStatus = 4;
        } else if (dealer.getSum() > user.getSum()) {
          gameStatus = 2;
        } else if (dealer.getSum() < user.getSum()) {
          gameStatus = 1;
        } else if (dealer.getSum() == user.getSum()) {
          gameStatus = 7;
        }
        gameEnded = true;
        justDealt = false;
      } else if (!splitHand && splitInProg) {
        //second hand of split (normal hand)
        while (dealer.getSum() <= 16) {
          dealer.addCard(deck.getCard());
        }
        if (dealer.getSum() == 21) {
          gameStatus = 2;
          gameStatus2 = 2;
        } else if (dealer.getSum() > 21) {
          gameStatus = 4;
          gameStatus2 = 4;
        } else if (dealer.getSum() > user.getSum()) {
          gameStatus = 2;
        } else if (dealer.getSum() < user.getSum()) {
          gameStatus = 1;
        } else if (dealer.getSum() == user.getSum()) {
          gameStatus = 7;
        }
        if (dealer.getSum() == 21) {
          gameStatus = 2;
          gameStatus2 = 2;
        } else if (dealer.getSum() > 21) {
          gameStatus = 4;
          gameStatus2 = 4;
        } else if (dealer.getSum() > userSplit.getSum()) {
          gameStatus2 = 2;
        } else if (dealer.getSum() < userSplit.getSum()) {
          gameStatus2 = 1;
        } else if (dealer.getSum() == userSplit.getSum()) {
          gameStatus2 = 7;
        }
        splitResult = true;
        splitInProg = false;
        gameEnded = true;
        justDealt = false;
      } else if (splitHand && splitInProg) {
        switchHands();
      }
    }
    notifyListeners();
  }

  void adjustBet(double value) {
    bet = value;
    //_PlayerDocState.
    notifyListeners();
  }

  void endGame() {
    print("Players Cards");
    for (var i in user._cards) {
      print("${i.getId()} ${i.getSuit()} ${i.getValue()}");
    }
    print("Players Split Cards");
    for (var i in userSplit._cards) {
      print("${i.getId()} ${i.getSuit()} ${i.getValue()}");
    }
    if (gameStatus == 1 || gameStatus == 4) {
      stack += (bet * 2.0);
    } else if (gameStatus == 5) {
      stack += (bet * 2.5);
    } else if (gameStatus == 7) {
      stack += bet;
    }
    if (gameStatus2 == 1 || gameStatus2 == 4) {
      stack += (bet * 2.0);
    } else if (gameStatus2 == 5) {
      stack += (bet * 2.5);
    } else if (gameStatus2 == 7) {
      stack += bet;
    }
    if (doubleTaken) {
      bet = bet / 2.0;
    }
    doubleOption = false;
    doubleTaken = false;
    splitOption = false;
    gameStatus = 0;
    gameStatus2 = 0;
    if (stack == 0.0) {
      gameStatus = 10;
    } else if (stack < bet) {
      bet = stack;
      gameStarted = false;
    } else {
      gameStarted = false;
    }

    user.clearHand();
    dealer.clearHand();
    userSplit.clearHand();

    //doubleOption = false;
    //splitOption = false;
    splitHand = false;
    splitInProg = false;
    splitResult = false;

    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ...

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = ProfilePage();
        break;
      case 2:
        page = InfoPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // ...
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.info),
                    label: Text('Info'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: 400.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DealerDoc(),
              ],
            ),
          ),
          //DealerDoc(),
          //SizedBox(height: 125),
          Expanded(
            child: Column(
              children: [
                Gamefunc(),
                SizedBox(height: 10),
                Gamestatus(),
              ],
            ),
          ),

          SizedBox(height: 10),
          Baseline(
            baseline: 10,
            baselineType: TextBaseline.ideographic,
            child: PlayerDoc(),
          ),
        ]),
      ),
    );
  }
}

// ...
// ...

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    var temp = true;

    if (temp) {
      return Center(
        child: Text('No profile yet.'),
      );
    }
  }
}
/*
class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    String infoText = """

    """;

    return Column(
      children: [

      ],
    );
    

  }
}
*/

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'), // Set app bar title
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add some padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blackjack Rules',
              style: TextStyle(
                // Style the heading
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0), // Add some space between heading and text
            Text(
              '''
              Blackjack is a classic card game where the goal is to beat the dealer by getting a hand closer to 21 without going over. 
              Face cards are worth 10, aces can be 1 or 11, and other cards are worth their pip value. 
              You can hit (get another card), stand (stop receiving cards), double down (bet double for one more card) to reach 21, or split (if your cards have the same value). Double and split actions are only available after the hand is dealt, and unavailable after any subsequent actions.
              This game is played with 6 Decks of cards.
              Try your luck!''',
              style: TextStyle(
                // Style the paragraph text
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerDoc extends StatefulWidget {
  PlayerDoc({
    super.key,
    //required this.pair,
  });

  @override
  State<PlayerDoc> createState() => _PlayerDocState();
}

class _PlayerDocState extends State<PlayerDoc> {
  //final WordPair pair;
  //double _currentSliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //var sliderState = context.watch<_CupertinoSliderExampleState>();
    final theme = Theme.of(context);
    String currStack = appState.stack.toStringAsFixed(2);
    String currBet = appState.bet.toStringAsFixed(2);
    //String x = "KH";
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    //int temp = appState.user.getSum();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //BigCard(pair: pair),

        //ListView(
        //children: appState.user._cards,
        //)
        /*
        Card(
          
          child: Image.asset('images/$x.png', height: 60.0, width: 30.0),
        ),
        */
        /*
        Container(
          width: 60.0,
          child: Stack(
            children: [
              Image.asset('images/$x.png', height: 90.0, width: 45.0),
              Positioned(
                top:
                    -10.0, // Adjust for desired vertical offset (negative for above)
                right:
                    -8.0, // Adjust for desired horizontal offset (negative for right)
                child: Image.asset('images/$x.png', height: 90.0, width: 45.0),
              )
            ],
            //Image.asset('images/$x.png', height: 90.0, width: 45.0),
            //Image.asset('images/$x.png', height: 90.0, width: 45.0),
          ),
        ),
        */
        //Image.asset('images/$x.png', height: 90.0, width: 45.0),
        //if (appState.splitInProg)

        if (!appState.splitHand) PlayerHand(),
        /*
        if (!appState.splitHand)
          for (var card in appState.user._cards.reversed)
            
            Card(
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${card.getId()} of ${card.getSuit()}",
                    style: TextStyle(fontSize: 10.0)),
              ),
            ),
        */
        if (appState.splitHand) PlayerHandSplit(),
        /*
          for (var card in appState.userSplit._cards.reversed)
            Card(
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${card.getId()} of ${card.getSuit()}",
                    style: TextStyle(fontSize: 10.0)),
              ),
            ),
        */
        //SizedBox(height: 1),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (appState.doubleOption)
              ElevatedButton(
                onPressed: () {
                  appState.doubleBet();
                },
                //icon: Icon(icon),

                style: ElevatedButton.styleFrom(
                    fixedSize: Size(60, 40), padding: EdgeInsets.all(5.0)),
                child: Text('Double', style: TextStyle(fontSize: 11.5)),
              ),
            if (appState.doubleOption) SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                appState.hit();
              },
              //icon: Icon(icon),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(65, 45), padding: EdgeInsets.all(5.0)),
              child: Text('Hit'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                appState.stand();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(65, 45), padding: EdgeInsets.all(5.0)),
              child: Text('Stand'),
            ),
            if (appState.splitOption) SizedBox(width: 10),
            if (appState.splitOption)
              ElevatedButton(
                onPressed: () {
                  appState.split();
                },
                //icon: Icon(icon),

                style: ElevatedButton.styleFrom(
                    fixedSize: Size(35, 35), padding: EdgeInsets.all(5.0)),
                child: Text('Split', style: TextStyle(fontSize: 11.5)),
              ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              //color: Theme.of(context).colorScheme.inversePrimary,
              elevation: 1.0,

              child: Text("Stack: "),
            ),
            SizedBox(width: 5),
            Card(
              //color: Theme.of(context).colorScheme.inversePrimary,
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                //child: Text(String.format("%.2f", appState.stack)),
                child: Text(currStack),
              ),
            ),
            SizedBox(width: 10),
            Card(
              //color: Theme.of(context).colorScheme.inversePrimary,
              elevation: 1.0,

              child: Text("Bet: "),
            ),
            SizedBox(width: 5),
            Card(
              //color: Theme.of(context).colorScheme.inversePrimary,
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(currBet),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        /*
        CupertinoSlider(
          key: const Key('slider'),
          value: _currentSliderValue,
          // This allows the slider to jump between divisions.
          // If null, the slide movement is continuous.
          divisions: 20,
          // The maximum slider value
          max: appState.stack,
          activeColor: const Color.fromARGB(255, 82, 222, 173),
          thumbColor: Color.fromARGB(255, 82, 101, 222),
          // This is called when sliding is started.
          onChangeStart: (double value) {
            //setState(() {
            //_sliderStatus = 'Sliding';
            //});
            _currentSliderValue = value;
          },
          // This is called when sliding has ended.
          onChangeEnd: (double value) {
            //_sliderStatus = 'Finished sliding';
            _currentSliderValue = value;
            //value: value;
            //notifyListeners();
          },
          // This is called when slider value is changed.
          onChanged: (double value) {
            _currentSliderValue = value;
            if (!appState.gameStarted){
              appState.bet = _currentSliderValue;
            }
          },
        ),*/
        if (!appState.gameStarted) CupertinoSliderExample(),

        SizedBox(height: 60),
      ],
    );
  }
}

class CupertinoSliderExample extends StatefulWidget {
  const CupertinoSliderExample({super.key});

  @override
  State<CupertinoSliderExample> createState() => _CupertinoSliderExampleState();
}

class _CupertinoSliderExampleState extends State<CupertinoSliderExample> {
  //var appState = context.watch<MyAppState>();
  double _currentSliderValue = 10.0;
  String? _sliderStatus;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.stack >= appState.bet) {
      _currentSliderValue = appState.bet;
    } else {
      _currentSliderValue = appState.stack;
    }

    //var playerState = context.watch<_PlayerDocState>();
    return CupertinoPageScaffold(
      //navigationBar: const CupertinoNavigationBar(
      //middle: Text('CupertinoSlider Sample'),
      //),

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Display the current slider value.
            Text('Adjust Bet'),
            //Text('$_currentSliderValue'),
            CupertinoSlider(
              key: const Key('slider'),
              value: _currentSliderValue,
              // This allows the slider to jump between divisions.
              // If null, the slide movement is continuous.
              divisions: 20,
              // The maximum slider value
              max: appState.stack,
              min: 0.0,
              activeColor: const Color.fromARGB(255, 222, 82, 82),
              thumbColor: const Color.fromARGB(255, 222, 82, 82),
              // This is called when sliding is started.
              onChangeStart: (double value) {
                setState(() {
                  _sliderStatus = 'Sliding';
                });
              },
              // This is called when sliding has ended.
              onChangeEnd: (double value) {
                setState(() {
                  _sliderStatus = 'Finished sliding';
                });
              },
              // This is called when slider value is changed.
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  //playerState._currentSliderValue = value;
                  //appState.bet = value;
                  appState.adjustBet(value);
                });
              },
            ),
            /*
            Text(
              _sliderStatus ?? '',
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 12,
                  ),
            ),*/
          ],
        ),
      ),
    );
  }
}

class PlayerHand extends StatelessWidget {
  const PlayerHand({
    super.key,
    //required this.pair,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //int i = 1;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    //int temp = appState.dealer.getSum();
    return Container(
      height: 180.0,
      width: 180.0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          if (appState.user._cards.isNotEmpty)
            Image.asset(
                'images/${appState.user._cards.elementAt(0).getId()}${appState.user._cards.elementAt(0).getSuit()}.png',
                height: 90.0,
                width: 45.0),
          for (var card in appState.user._cards.skip(1))
            Positioned(
              top: -15.0 * (appState.user._cards.indexOf(card) - 5),
              right: -10.0 * (appState.user._cards.indexOf(card) - 7),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Image.asset(
                'images/${card.getId()}${card.getSuit()}.png',
                height: 90.0,
                width: 45.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
        ],
      ),
    );
  }
}

class PlayerHandSplit extends StatelessWidget {
  const PlayerHandSplit({
    super.key,
    //required this.pair,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //int i = 1;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    //int temp = appState.dealer.getSum();
    return Container(
      height: 180.0,
      width: 180.0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          if (appState.userSplit._cards.isNotEmpty)
            Image.asset(
                'images/${appState.userSplit._cards.elementAt(0).getId()}${appState.userSplit._cards.elementAt(0).getSuit()}.png',
                height: 90.0,
                width: 45.0),
          for (var card in appState.userSplit._cards.skip(1))
            Positioned(
              top: -15.0 * (appState.userSplit._cards.indexOf(card) - 5),
              right: -10.0 * (appState.userSplit._cards.indexOf(card) - 7),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Image.asset(
                'images/${card.getId()}${card.getSuit()}.png',
                height: 90.0,
                width: 45.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
        ],
      ),
    );
  }
}

class DealerHandOne extends StatelessWidget {
  const DealerHandOne({
    super.key,
    //required this.pair,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //int i = 1;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    //int temp = appState.dealer.getSum();
    return Container(
      height: 180.0,
      width: 180.0,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          if (appState.dealer._cards.isNotEmpty)
            Image.asset('images/back.png', height: 90.0, width: 45.0),
          for (var card in appState.dealer._cards.skip(1))
            Positioned(
              top: -15.0 * (appState.dealer._cards.indexOf(card) - 3),
              right: -9.0 * (appState.dealer._cards.indexOf(card) - 7),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Image.asset(
                'images/${card.getId()}${card.getSuit()}.png',
                height: 90.0,
                width: 45.0,
                alignment: Alignment.topCenter,
              ),
            ),
        ],
      ),
    );
  }
}

class DealerHandTwo extends StatelessWidget {
  const DealerHandTwo({
    super.key,
    //required this.pair,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    //int i = 1;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    //int temp = appState.dealer.getSum();
    return Container(
      height: 180.0,
      width: 180.0,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          if (appState.dealer._cards.isNotEmpty)
            Image.asset(
                'images/${appState.dealer._cards.elementAt(0).getId()}${appState.dealer._cards.elementAt(0).getSuit()}.png',
                height: 90.0,
                width: 45.0),
          for (var card in appState.dealer._cards.skip(1))
            Positioned(
              top: 15.0 * (appState.dealer._cards.indexOf(card) + 1),
              right: -9.0 * (appState.dealer._cards.indexOf(card) - 7),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Image.asset(
                'images/${card.getId()}${card.getSuit()}.png',
                height: 90.0,
                width: 45.0,
                alignment: Alignment.topCenter,
              ),
            ),
        ],
      ),
    );
  }
}

class DealerDoc extends StatelessWidget {
  const DealerDoc({
    super.key,
    //required this.pair,
  });

  //final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    //int temp = appState.dealer.getSum();
    if (appState.justDealt && appState.gameStarted && !appState.gameEnded) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //BigCard(pair: pair),
          SizedBox(height: 100),
          Card(
            //color: Theme.of(context).colorScheme.inversePrimary,
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Dealer"),
            ),
          ),
          DealerHandOne(),
          /*
          SizedBox(height: 20),
          Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("?", style: TextStyle(fontSize: 10.0)),
            ),
          ),
          Card(
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${appState.dealer._cards.elementAt(1).getId()} of ${appState.dealer._cards.elementAt(1).getSuit()}",
                  style: TextStyle(fontSize: 10.0)),
            ),
          ),
          */
          SizedBox(height: 10),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //BigCard(pair: pair),
          SizedBox(height: 100),
          Card(
            //color: Theme.of(context).colorScheme.inversePrimary,
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Dealer"),
            ),
          ),
          //SizedBox(height: 20),
          DealerHandTwo(),
          /*
          for (var card in appState.dealer._cards)
            Card(
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${card.getId()} of ${card.getSuit()}",
                    style: TextStyle(fontSize: 10.0)),
              ),
            ),
          */
          SizedBox(height: 10),
        ],
      );
    }
  }
}

class Gamefunc extends StatelessWidget {
  const Gamefunc({
    super.key,
    //required this.pair,
  });

  //final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            appState.deal();
          },
          //icon: Icon(icon),
          child: Text('Deal'),
        ),
        SizedBox(width: 50),

        if (appState.gameEnded) ContBut(),

        //BigCard(pair: pair),
        //SizedBox(height: 100),

        SizedBox(height: 10),
      ],
    );
  }

  //void deal() {
  //MyAppState.user.addCard(MyAppState.deck.getCard());
  //}
}

class ContBut extends StatelessWidget {
  const ContBut({
    super.key,
    //required this.pair,
  });

  //final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            if (appState.splitHand) {
              //appState.endGame();
              appState.switchHands();
            } else if (appState.splitInProg) {
              //appState.endGame();
              //appState.splitResult = true;
              //appState.gameEnded = true;
              appState.splitInProg = false;
            } else {
              appState.endGame();
              appState.gameEnded = false;
              appState.justDealt = false;
            }
            //appState.toggleFavorite();
          },
          //icon: Icon(icon),
          child: Text('Continue'),
        ),
      ],
    );
  }
}

class Gamestatus extends StatelessWidget {
  const Gamestatus({
    super.key,
    //required this.pair,
  });

  // 0 = no label
  // 1 = player wins
  // 2 = dealer wins
  // 3 = player busts
  // 4 = dealer busts
  // 5 = player has blackjack
  // 6 = dealer has blackjack
  // 7 = push
  // 8 = Split: Hand 1
  // 9 = Split: Hand 2

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    int status = appState.gameStatus;
    int status2 = appState.gameStatus2;
    String result;
    String result2;

    if (status == 0) {
      result = "";
    } else if (status == 1) {
      result = "You Win!";
    } else if (status == 2) {
      result = "Dealer Wins";
    } else if (status == 3) {
      result = "Bust, You Lose";
    } else if (status == 4) {
      result = "Dealer Busts, You Win!";
    } else if (status == 5) {
      result = "Blackjack, You Win!";
    } else if (status == 6) {
      result = "Dealer has Blackjack, You Lose";
    } else if (status == 7) {
      result = "Push!";
    } else if (status == 8) {
      result = "Split: Hand 1";
    } else if (status == 9) {
      result = "Split: Hand 2";
    } else if (status == 10) {
      result = "Stack Empty. Can't Deal.";
    } else {
      result = "Error";
    }
    if (status2 == 0) {
      result2 = "";
    } else if (status2 == 1) {
      result2 = "You Win!";
    } else if (status2 == 2) {
      result2 = "Dealer Wins";
    } else if (status2 == 3) {
      result2 = "Bust, You Lose";
    } else if (status2 == 4) {
      result2 = "Dealer Busts, You Win!";
    } else if (status2 == 5) {
      result2 = "Blackjack, You Win!";
    } else if (status2 == 6) {
      result2 = "Dealer has Blackjack, You Lose";
    } else if (status2 == 7) {
      result2 = "Push!";
    } else if (status2 == 8) {
      result2 = "Split: Hand 1";
    } else if (status2 == 9) {
      result2 = "Split: Hand 2";
    } else if (status2 == 10) {
      result2 = "Stack Empty. Can't Deal.";
    } else {
      result2 = "Error";
    }
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!appState.splitResult)
            Card(
              //child: Flexible(
              child: Text(result),
              //),
              //child: Text(result),
            ),
          if (appState.splitResult)
            Card(
              //child: Flexible(
              child: Text("Hand 2: ${result}"),
              //),
            ),
          if (appState.splitResult) SizedBox(width: 5.0),
          if (appState.splitResult)
            Card(
              //child: Flexible(
              child: Text("Hand 1: ${result2}"),
              //),
            ),
        ],
      ),
    );
  }

  //void deal() {
  //MyAppState.user.addCard(MyAppState.deck.getCard());
  //}
}

class Card1 {
  final int num;
  final String suit;
  final String id;
  final int value;

  const Card1(this.num, this.suit, this.id, this.value);

  int getValue() {
    return value;
  }

  String getId() {
    return id;
  }

  String getSuit() {
    return suit;
  }
}

class Player {
  List<Card1> _cards = [];
  int handSum = 0;
  int hasAce = 0;
  //List<Card1> _cardsSplit = [];

  Player();

  void addCard(Card1 card) {
    this._cards.add(card);
    this.handSum += card.getValue();
    if (card.getValue() == 11) {
      this.hasAce += 1;
    }
  }

  int getSum() {
    if (this.handSum > 21) {
      if (this.hasAce > 0) {
        return (this.handSum - (10 * this.hasAce));
      }
    }
    return this.handSum;
  }

  void clearHand() {
    this.handSum = 0;
    this._cards = [];
    this.hasAce = 0;
  }

  Card1 pullCard() {
    Card1 temp = this._cards.elementAt(1);
    this._cards.removeAt(1);
    this.handSum -= temp.getValue();
    return temp;
  }
}

class Deck {
  List<Card1> _cards = []; // Use an unmodifiable list for the deck
  int currentNum = 0;

  Deck() {
    _cards = createDeck();
    _cards.shuffle();
  }

  List<Card1> createDeck() {
    List<Card1> cards = [];
    //int i = 0;
    //int j = 0;

    int value = 0;
    int s = 1;
    for (int i = 1; i <= 24; i++) {
      for (int j = 1; j <= 13; j++) {
        if (j <= 9) {
          value = j + 1;
        } else if (9 < j && j < 13) {
          value = 10;
        } else if (j == 13) {
          value = 11;
        }
        cards.add(Card1(s, suits[(i - 1)%4], ids[j - 1], value));
        s++;
      }
    }
    return cards;
  }

  Card1 getCard() {
    if (this.currentNum > 40) {
      _cards.shuffle();
      this.currentNum = 0;
    }
    Card1 current = _cards.elementAt(this.currentNum);
    print("Current card num ${this.currentNum}");
    this.currentNum++;
    return current;
  }

  List<Card1> getCards() =>
      List.unmodifiable(_cards); // Return an unmodifiable list
}

// Enums for suits and ids (optional, but recommended for Flutter)
const List<String> suits = ["H", "D", "C", "S"];
const List<String> ids = [
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
  "J",
  "Q",
  "K",
  "A"
];
