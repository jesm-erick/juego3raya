import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:juego/models/juego.dart';

import 'package:juego/ui/theme/color.dart';
import 'package:juego/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerJ1;
  late TextEditingController _controllerJ2;
  var winner;

  List labelList = [" ", " ", " ", " ", " ", " ", " ", " ", " "];
  bool enableDisable = false;
  String turno = "";
  String ganador = "";
  bool clickTurno = false;
  int chance_flag = 0;

  void btnInicio() {
    labelList.replaceRange(0, 9, ["", "", "", "", "", "", "", "", ""]);
    ganador = "";
    enableDisable = true;
    chance_flag = 0;
    Random rnd = new Random();
    int min = 13, max = 42;
    int r = min + rnd.nextInt(max - min);
    if (r % 2 == 0) {
      turno = "J1:${_controllerJ1.value.text}-(X)";
    } else {
      turno = "J2:${_controllerJ2.value.text}-(O)";
    }
  }

  void btnAnular() {
    labelList.replaceRange(0, 9, ["", "", "", "", "", "", "", "", ""]);
    enableDisable = false;
    turno = "";
  }

  //adding the necessary variables
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //the score are for the different combination of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  //let's declare a new Game components

  Game game = Game();

  //let's initi the GameBoard
  @override
  void initState() {
    _controllerJ1 = new TextEditingController(text: '');
    _controllerJ2 = new TextEditingController(text: '');
    winner = '';
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //     MainMenuScreen.routeName: (context) => const MainMenuScreen(),
              // JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
              // CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
              // GameScreen.routeName: (context) => const GameScreen(),

              const Text(
                '3 en Raya',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Paytone',
                ),
              ),

//Aqui
              _buidForm(),
              // Text(
              //   //"It's ${lastValue} turn".toUpperCase(),
              //   style: TextStyle(
              //     color: Colors.red,
              //     fontSize: 58,
              //   ),
              // ),

              SizedBox(
                height: 20.0,
              ),
              //now we will make the game board
              //but first we will create a Game class that will contains all the data and method that we will need
              Container(
                width: boardWidth,
                height: boardWidth,
                child: GridView.count(
                  crossAxisCount: Game.boardlenth ~/
                      3, // the ~/ operator allows you to evide to integer and return an Int as a result
                  padding: EdgeInsets.all(16.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: List.generate(Game.boardlenth, (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              //when we click we need to add the new value to the board and refrech the screen
                              //we need also to toggle the player
                              //now we need to apply the click only if the field is empty
                              //now let's create a button to repeat the game

                              if (game.board![index] == "") {
                                setState(() {
                                  game.board![index] = lastValue;
                                  turn++;
                                  gameOver = game.winnerCheck(
                                      lastValue, index, scoreboard, 3);

                                  if (gameOver) {
                                    if (lastValue == "X") {
                                      winner = _controllerJ1.text;
                                      result = "$winner es el ganador";
                                    } else {
                                      winner = _controllerJ2.text;
                                      result = "$winner es el ganador";
                                    }
                                  } else if (!gameOver && turn == 9) {
                                    result = "It's a Draw!";
                                    gameOver = true;
                                  }
                                  if (lastValue == "X")
                                    lastValue = "O";
                                  else
                                    lastValue = "X";
                                });
                              }
                            },
                      child: Container(
                        width: Game.blocSize,
                        height: Game.blocSize,
                        decoration: BoxDecoration(
                          color: MainColor.secondaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            game.board![index],
                            style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.red
                                  : Colors.white,
                              fontSize: 64.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                result,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 248, 4), fontSize: 54.0),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _controllerJ1 = new TextEditingController(text: '');
                    _controllerJ2 = new TextEditingController(text: '');
                    //erase the board
                    game.board = Game.initGameBoard();
                    lastValue = "X";
                    gameOver = false;
                    turn = 0;
                    result = "";
                    scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                  });
                },
                icon: Icon(Icons.replay),
                label: Text("Repetir Juego"),
              ),
            ],
          ),
        ));
    //the first step is organise our project folder structure
  }

  Form _buidForm() {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre Jugador 1:',
                  ),
                  controller: _controllerJ1,
                ),
                SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre Jugador 2:',
                  ),
                  controller: _controllerJ2,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          // print(_controllerJ1.text);
                          setState(() {
                            btnInicio();
                          });
                        },
                        child: Text("Iniciar")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         btnAnular();
                    //       });
                    //     },
                    //     child: Text("Anular")),
                  ],
                )
              ],
            )));
  }
}
