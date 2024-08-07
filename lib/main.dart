// ignore_for_file: unnecessary_this, unnecessary_breaks

//import 'package:english_words/english_words.dart';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
//import 'package:collection/collection.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';


//import 'package:audioplayers/audioplayers_api.dart';
//import 'package:auth0_flutter/auth0_flutter.dart';

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
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              // Define your custom button style here
              //foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(16, 34, 255, 178),
              elevation: 4.5,
              //textStyle: TextStyle(fontSize: 18.0),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              // You can add other style properties like padding, shadows, etc.
            ),
          ),
          useMaterial3: true,
          colorScheme:
              //ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 34, 34)),
              ColorScheme.highContrastDark(
                  primary: Color.fromARGB(255, 34, 255, 178),
                  secondary: Color.fromARGB(255, 89, 219, 228)),
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

  bool audioOn = true;
  //String volumeImage = "volume_up_sharp";
  //Icon vol = Icon(Icon.volume_up_sharp);


  
  final soundPlayer = AudioPlayer();
  //final soundPlayer = AudioPlayer();

  //String getVolIcon(){
   // return volumeImage;
  //}

  void toggleAudio() {
    if (audioOn){
      audioOn = false;
      //volumeImage = "volume_mute_sharp";
    } else {
      audioOn = true;
      //volumeImage = "volume_up_sharp";
    }
    notifyListeners();
  }

  Future<void> playSound(String name) async{
    //String audioPath = "assets/sounds/deal.mp3";
    //String out = '/Users/josephstefurak/Desktop/IOS_Blackjack_App/sounds/deal.mp3';
    String out = "$name.mp3";
    String temp = '/Users/josephstefurak/Desktop/IOS_Blackjack_App/assets/$name.mp3';

    //String out = "/Users/josephstefurak/Desktop/IOS_Blackjack_App/assets/sounds/deal.mp3";
    //assets/sounds/deal.mp3
    ///Users/josephstefurak/Desktop/IOS_Blackjack_App/sounds/deal.mp3
    
    //await soundPlayer.setSource(AssetSource(out));
    //await soundPlayer.

    if (audioOn) {
      
      //await soundPlayer.play(out, isLocal: true);
      //assets/deal.mp3
      try {
       //await soundPlayer.setReleaseMode()
        await soundPlayer.setSource(AssetSource(out));
        await soundPlayer.play(AssetSource(out));
        print("Playing");
      } catch(e) {
        print('Error Playing Sound: $e');
      } finally {
        //await soundPlayer.stop();
      }
    }
    //await soundPlayer.play(url);
    //await player.play(AssetSource(audioPath));
   
  }
  /*
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose(); // Release resources when the widget is disposed
  }

  // ... rest of your widget code

  void playSoundEffect() async {
    //await audioPlayer.setSource(AssetSource('button_click.wav'));
    await audioPlayer.play('sounds/deal.mp3');
  }
  */
  /*

  Credentials? _credentials;

  late Auth0 auth0;
  late UserProfile userProf;
  */

  /*
  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-570cfuzk7ci8akce.us.auth0.com', 'mxaUiHIEwVtG5vepQGAiezfZ4DjSdTQ5');
  }

  late UserProfile tempUser;
  */


  Future<void> deal() async {
    if (!gameStarted) {
      gameStarted = true;
      justDealt = true;
      print("Dealt");
      //bet = _CupertinoSliderExampleState()._currentSliderValue;
      print("${bet}");
      stack -= bet;
      user.addCard(deck.getCard());
      //playSound("deal");
      playSound("deal2");
      notifyListeners();
      
      await Future.delayed(const Duration(milliseconds: 500));
      dealer.addCard(deck.getCard());
      playSound("deal2");
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      user.addCard(deck.getCard());
      playSound("deal2");
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      dealer.addCard(deck.getCard());
      playSound("deal2");

      if ((user.getSum() == 21) && (dealer.getSum() == 21)){
        gameStatus = 7;
        gameEnded = true;
        justDealt = false;
      } else if (user.getSum() == 21) {
        gameStatus = 5;
        gameEnded = true;
        justDealt = false;
      } else if (dealer.getSum() == 21) {
        
        gameStatus = 6;
        gameEnded = true;
          
        justDealt = false;
        
      } else {
        
        if (stack >= bet) {
          //stack -= bet;
          //bet = (bet*2.0);

          doubleOption = true;
          if (user._cards.elementAt(0).getValue() ==
              user._cards.elementAt(1).getValue()) {
            splitOption = true;
          }
        }
        gameStarted = true;
        justDealt = true;

      }

      
      //gameEnded = false;
      

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
      playSound("deal");
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

  Future<void> split() async {
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
      playSound("deal");
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      userSplit.addCard(deck.getCard());
      playSound("deal");
      /*
      if (userSplit.getSum() == 21) {
        gameStatus2 = 1;
        //justDealt = false;
        gameEnded = true;
      }
      */
    }
    notifyListeners();
  }

  Future<void> switchHands() async {
    splitHand = false;
    gameEnded = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    user.addCard(deck.getCard());
    playSound("deal");
    notifyListeners();

    gameStatus = 9;
    //gameStatus2 = 0;

    if (user.getSum() == 21) {
      /*
      gameStatus = 1;
      justDealt = false;
      gameEnded = true;
      */
      stand();
    }
  }

  // Function for hitting (getting another card) - to be implemented later
  Future<void> hit() async {
    // Implement logic for adding a card to the user's hand
    if (gameStatus != 10) {
      if (gameStarted && !gameEnded) {
        doubleOption = false;
        splitOption = false;
        if (splitHand) {
          userSplit.addCard(deck.getCard());
          playSound("deal");
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 1500));
          //notifyListeners();
          if (userSplit.getSum() == 21) {
            stand();
            /*
            gameStatus2 = 1;
            //switchHands();
            justDealt = false;
            gameEnded = true;
            */
          } else if (userSplit.getSum() > 21) {
            print("First split bust");
            //gameEnded = true;
            gameStatus2 = 3;
            switchHands();
            print("${gameStatus2}");
            //justDealt = false;
          }
        } else {
          user.addCard(deck.getCard());
          playSound("deal");
          //playSoundEffect();
          if (user.getSum() == 21) {
            /*
            gameStatus = 1;
            justDealt = false;
            gameEnded = true;
            */
            stand();
          } else if (user.getSum() > 21) {
            if (splitInProg) {
              splitResult = true;
              splitInProg = false;
              if (21 < userSplit.getSum()) {
                gameStatus2 = 3;
              } else if (dealer.getSum() > userSplit.getSum()) {
                gameStatus2 = 2;
              } else if (dealer.getSum() < userSplit.getSum()) {
                gameStatus2 = 1;
              } else if (dealer.getSum() == userSplit.getSum()) {
                gameStatus2 = 7;
              }
            }

            gameEnded = true;
            justDealt = false;
            gameStatus = 3;
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> stand() async {
    if (gameStarted && !gameEnded) {
      doubleOption = false;
      splitOption = false;
      await Future.delayed(const Duration(milliseconds: 500));
      if (!splitHand && !splitInProg) {
        //normal hand
        //gameEnded = true;
        justDealt = false;
        notifyListeners();
        while (dealer.getSum() <= 16) {
          await Future.delayed(const Duration(milliseconds: 750));
          dealer.addCard(deck.getCard());
          playSound("deal");
          notifyListeners();
        }
        
        if (dealer.getSum() > 21) {
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
          await Future.delayed(const Duration(milliseconds: 750));
          dealer.addCard(deck.getCard());
          playSound("deal");
          notifyListeners();
        }
        if (dealer.getSum() == 21) {
          gameStatus = 2;
          if (userSplit.getSum() <= 21) {
            gameStatus2 = 2;
          }
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
        } else if (21 < userSplit.getSum()) {
          gameStatus2 = 3;
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
    await Future.delayed(const Duration(milliseconds: 500));
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
      playSound("win");
    } else if (gameStatus == 5) {
      stack += (bet * 2.5);
      playSound("win");
    } else if (gameStatus == 7) {
      stack += bet;
    }
    if (gameStatus2 == 1 || gameStatus2 == 4) {
      playSound("win");
      stack += (bet * 2.0);
    } else if (gameStatus2 == 5) {
      playSound("win");
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
      //gameEnded = true;
      //gameStarted = false;
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

  //final player = AudioPlayer();
  /*
  Future<void> playSound(String name) async{
    String audioPath = 'sounds/${name}.mp3';

    await soundPlayer.play(audioPath);
    //await player.play(AssetSource(audioPath));
   
  }
  */
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
    var appState = context.watch<MyAppState>();

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      /*
      case 1:
        page = ProfilePage();
        break;
      */
      case 1:
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
              /*
              child: Column(
                children: [
                  NavigationRail(
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
                  IconButton(
                    onPressed: () {
                      appState.toggleAudio(); 
                    }, 
                    //icon: Icon(Icons.${appState.getVolIcon()}),
                    icon: Icon(appState.audioOn ? Icons.volume_up : Icons.volume_off),
                  ),
                ],
              ),
              */
              child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      /*
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                      */
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
          SizedBox(height: 75),
          Container(
            height: 255.0,
            /*
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            */
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
/*

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-570cfuzk7ci8akce.us.auth0.com', 'mxaUiHIEwVtG5vepQGAiezfZ4DjSdTQ5');
  }

  late UserProfile tempUser;
  //int x = 0;
  

  @override
  final TextStyle comingSoonStyle =
      TextStyle(color: Color.fromARGB(255, 89, 228, 158));

  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    _credentials = appState._credentials;//
    
    if (_credentials != null){
      tempUser = appState.userProf;
      //print(appState._credentials?.user.customClaims?.entries.firstOrNull?.value);
    }
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
      body: Center(
        child: Column(
          // Change to Column for vertical alignment
          mainAxisAlignment:
              MainAxisAlignment.start, // Center content vertically
          children: [
            SizedBox(height: 100,),
            Icon(Icons.person,
                size: 50.0,
                color: Color.fromARGB(255, 77, 187, 132)), // Add icon
            //Text('Profile', style: comingSoonStyle),
            SizedBox(height: 50,),
            Text('Toggle Audio:', style: comingSoonStyle),
            
            IconButton(
              onPressed: () {
                appState.toggleAudio(); 
              }, 
              //icon: Icon(Icons.${appState.getVolIcon()}),
              icon: Icon(appState.audioOn ? Icons.volume_up : Icons.volume_off),
            ),
            SizedBox(height: 50,),
            if (_credentials == null) 
              ElevatedButton(
                onPressed: () async {
                  // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
                  // useHTTPS is ignored on Android
                  final credentials =
                      await auth0.webAuthentication().login(useHTTPS: true);

                  setState(() {
                    _credentials = credentials;
                  });
                  appState._credentials = _credentials;//
                  tempUser = credentials.user;
                  appState.userProf = tempUser;
                  //appState.stack = 1.00 * (appState._credentials?.user.customClaims?.entries.lastOrNull?.value);  //firstOrNull?.value
                  //x = tempUser.userMetadata['stack'] as int;
                  Map stackValue3 = Map.castFrom(appState._credentials?.user.customClaims as dynamic);
                  double stackValue = 1.00 * stackValue3['https://myexamplesite.com/stack'];
                  appState.stack = stackValue;
                  
                },
                child: const Text("Log in")
              ),
            if (_credentials != null)
              Column(
                children: [
                  
                  ProfileView(user: tempUser),
                  ElevatedButton(
                    onPressed: () async {
                      // Use a Universal Link logout URL on iOS 17.4+ / macOS 14.4+
                      // useHTTPS is ignored on Android
                      await auth0.webAuthentication().logout(useHTTPS: true);
                      
                  
                      setState(() {
                        _credentials = null;
                      });
                      appState._credentials = _credentials;//
                    },
                    child: const Text("Log out")),
                ],
              ),
            

            
            
          ],
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.user}) : super(key: key);

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Map stackValue3 = Map.castFrom(appState._credentials?.user.customClaims as dynamic);
    double stackValue = 1.00 * stackValue3['https://myexamplesite.com/stack'];
    //print(stackValue3.keys);
    //print(stackValue3.values);
    //double stackValue2 = appState._credentials?.user.customClaims?.entries['https://myexamplesite.com/stack'];
    //print(stackValue);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (user.name != null) Text(user.name!),
        
        //user.stack 
        //if (user.stack != )
        //user.customClaims<'https://dev-570cfuzk7ci8akce.us.auth0.com/stack', stack!>
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Account Stack: "),
            SizedBox(width: 10),
            Text("$stackValue"),
            
            
          ]
          
          
        ),
        SizedBox(height: 10),
        Text("Save your stack coming soon."),
        //if (user.email != null) Text(user.email!)
      ],
    );
  }
}
*/

class InfoPage extends StatelessWidget {
  @override

  //final TextStyle comingSoonStyle = TextStyle(color: Color.fromARGB(255, 89, 228, 158));
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
          //title: Text('Info'), // Set app bar title
          ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add some padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Blackjack Rules',
              style: TextStyle(
                // Style the heading
                fontSize: 24.0,
                color: Color.fromARGB(255, 89, 228, 158),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text('Toggle Audio:', style: TextStyle(
                    // Style the heading
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 89, 228, 158),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    appState.toggleAudio(); 
                  }, 
                  //icon: Icon(Icons.${appState.getVolIcon()}),
                  icon: Icon(appState.audioOn ? Icons.volume_up : Icons.volume_off),
                ),
              ],
            ),
            
             // Add some space between heading and text
            SizedBox(height: 10.0),
            Text(
              '''
Blackjack is a classic card game where the goal is to beat the dealer by getting a hand closer to 21 without going over. 
              
Face cards are worth 10, aces can be 1 or 11, and other cards are worth their pip value. 
              
You can hit (get another card), stand (stop receiving cards), double down (bet double for one more card) to reach 21, or split (if your cards have the same value). Double and split actions are only available after the hand is dealt, and unavailable after any subsequent actions.
              
This game is played with 3 Decks of cards. The deck is reshuffled after three decks have been played.
              
      Try your luck!''',
              style: TextStyle(
                  // Style the paragraph text
                  fontSize: 14.0,
                  color: Color.fromARGB(255, 255, 255, 255),
              ),
              softWrap: true,
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
        if (!appState.splitHand) PlayerHand(),
        if (appState.splitHand) PlayerHandSplit(),
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
                appState.playSound("deal");
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
              color: Color.fromARGB(100, 100, 100, 100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                //child: Text(String.format("%.2f", appState.stack)),
                child: Text(currStack),
              ),
            ),
            SizedBox(width: 10),
            Card(
              //color: Color.fromARGB(100, 100, 100, 100),
              elevation: 1.0,

              child: Text("Bet: "),
            ),
            SizedBox(width: 5),
            Card(
              //color: Theme.of(context).colorScheme.inversePrimary,
              elevation: 4.0,
              color: Color.fromARGB(100, 100, 100, 100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(currBet),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
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
              activeColor: Color.fromARGB(255, 82, 194, 222),
              thumbColor: Color.fromARGB(255, 82, 222, 178),
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
      height: 220.0,
      width: 240.0,
      /*
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      */
      /*
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          if (appState.user._cards.isNotEmpty)
            Image.asset(
                'images/${appState.user._cards.elementAt(0).getId()}${appState.user._cards.elementAt(0).getSuit()}.png',
                height: 110.0,
                width: 55.0),
          for (var card in appState.user._cards.skip(1))
            Positioned(
              top: -15.0 * (appState.user._cards.indexOf(card) - 5),
              right: -13.0 * (appState.user._cards.indexOf(card) - 7),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Image.asset(
                'images/${card.getId()}${card.getSuit()}.png',
                height: 110.0,
                width: 55.0,
                //alignment: Alignment.bottomCenter,
              ),
            ),
        ],
      ),
      */
      child: Stack(
        //fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          if (appState.user._cards.isNotEmpty)
            Image.asset(
              'images/${appState.user._cards.elementAt(0).getId()}${appState.user._cards.elementAt(0).getSuit()}.png',
              height: 110.0,
              width: 55.0,
            ),
          for (var i = 1; i < appState.user._cards.length; i++)
            Positioned(
              //AlignmentGeometry: AlignmentDirectional.bottomCenter,
              top: 90 - (10.0 * i),
              //top: 15.0 * (appState.user._cards.length-i),
              //right: 90,
              right: 90 - (10.0 * (i)),
              child: Image.asset(
                'images/${appState.user._cards[i].getId()}${appState.user._cards[i].getSuit()}.png',
                height: 110.0,
                width: 55.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
          if (appState.user.getSum() > 0)
            Positioned(
              top: 90 - (10.0 * (appState.user._cards.length)),
              //right: -9.0 * (appState.dealer._cards.indexOf(card) - 7.5),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Card(
                color: Color.fromARGB(255, 9, 21, 23),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 2.4),
                  child: Text("(${appState.user.getSum()})",
                      style: TextStyle(
                        color: Color.fromARGB(255, 43, 203, 238),
                        fontSize: 15.0,
                      )),
                ),
                //),
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
      height: 220.0,
      width: 240.0,
      /*
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      */
      child: Stack(
        //fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          if (appState.userSplit._cards.isNotEmpty)
            Image.asset(
              'images/${appState.userSplit._cards.elementAt(0).getId()}${appState.userSplit._cards.elementAt(0).getSuit()}.png',
              height: 110.0,
              width: 55.0,
            ),
          for (var i = 1; i < appState.userSplit._cards.length; i++)
            Positioned(
              //AlignmentGeometry: AlignmentDirectional.bottomCenter,
              top: 90 - (10.0 * i),
              //top: 15.0 * (appState.user._cards.length-i),
              //right: 90,
              right: 90 - (10.0 * (i)),
              child: Image.asset(
                'images/${appState.userSplit._cards[i].getId()}${appState.userSplit._cards[i].getSuit()}.png',
                height: 110.0,
                width: 55.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
          if (appState.userSplit.getSum() > 0)
            Positioned(
              top: 90 - (10.0 * (appState.userSplit._cards.length)),
              //right: -9.0 * (appState.dealer._cards.indexOf(card) - 7.5),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Card(
                color: Color.fromARGB(255, 9, 21, 23),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 2.4),
                  child: Text("(${appState.userSplit.getSum()})",
                      style: TextStyle(
                        color: Color.fromARGB(255, 43, 203, 238),
                        fontSize: 15.0,
                      )),
                ),
                //),
              ),
            ),
        ],
      ),

      /*
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
      */
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
            //await Future.delayed(const Duration(seconds: 1));
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
      height: 200.0,
      width: 190.0,
      /*
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.yellow,
          width: 2.0,
        ),
      ),
      */
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
              right: -9.0 * (appState.dealer._cards.indexOf(card) - 7.5),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Image.asset(
                'images/${card.getId()}${card.getSuit()}.png',
                height: 90.0,
                width: 45.0,
                alignment: Alignment.topCenter,
              ),
            ),
          if (appState.dealer.getSum() > 0)
            Positioned(
              top: 80 + (15.0 * (appState.dealer._cards.length - 1)),
              //right: -9.0 * (appState.dealer._cards.indexOf(card) - 7.5),
              // 7), // Adjust offset for desired vertical stacking
              //right: -8.0,  // Adjust for desired horizontal offset (negative for right)

              child: Card(
                color: Color.fromARGB(255, 9, 21, 23),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 2.4),
                  child: Text("(${appState.dealer.getSum()})",
                      style: TextStyle(
                        color: Color.fromARGB(255, 43, 203, 238),
                        fontSize: 15.0,
                      )),
                ),
                //),
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
          //SizedBox(height: 100),
          Card(
            //color: Theme.of(context).colorScheme.inversePrimary,
            elevation: 1.0,
            color: Color.fromARGB(100, 100, 100, 100),
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
          //SizedBox(height: 10),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //BigCard(pair: pair),
          //SizedBox(height: 100),
          Card(
            //color: Theme.of(context).colorScheme.inversePrimary,
            elevation: 1.0,
            color: Color.fromARGB(100, 100, 100, 100),
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
          //SizedBox(height: 10),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!appState.splitResult && (status != 0))
            Card(
              //child: Flexible(

              color: Color.fromARGB(255, 9, 21, 23),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 2.4),
                child: Text(result,
                    style: TextStyle(
                      color: Color.fromARGB(255, 43, 203, 238),
                    )),
              ),
              //),
              //child: Text(result),
            ),
          if (appState.splitResult)
            Card(
              color: Color.fromARGB(255, 9, 21, 23),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 2.4),
                child: Text("Hand 2: ${result} (${appState.user.getSum()})",
                    style: TextStyle(
                      color: Color.fromARGB(255, 43, 203, 238),
                    )),
              ),
              //),
            ),
          if (appState.splitResult) SizedBox(width: 5.0),
          if (appState.splitResult)
            Card(
              color: Color.fromARGB(255, 9, 21, 23),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 2.4),
                child:
                    Text("Hand 1: ${result2} (${appState.userSplit.getSum()})",
                        style: TextStyle(
                          color: Color.fromARGB(255, 43, 203, 238),
                        )),
              ),
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
      int aces = this.hasAce;
      int tempHandVal = this.handSum;
      while ((tempHandVal > 21) && (aces > 0)) {
        tempHandVal -= 10;
        aces -= 1;
      }
      return tempHandVal;
      /*
      if (this.hasAce > 0) {
        return (this.handSum - (10 * this.hasAce));
      }
      */
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
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 13; j++) {
        if (j <= 9) {
          value = j + 1;
        } else if (9 < j && j < 13) {
          value = 10;
        } else if (j == 13) {
          value = 11;
        }
        cards.add(Card1(s, suits[(i - 1) % 4], ids[j - 1], value));
        s++;
      }
    }
    return cards;
  }

  Card1 getCard() {
    if (this.currentNum > 78) {
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

/*

class PlayAudio extends StatefulWidget {
  const PlayAudio({super.key});

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

  class _PlayAudioState extends State<PlayAudio> {

    final player = AudioPlayer();

    @override
    Widget build(BuildContext context) {

    }
  }

*/
