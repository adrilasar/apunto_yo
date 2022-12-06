import 'dart:math';

import 'package:apunto_yo/sql_helper.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'flip_card.dart';
import 'game.dart';

class GameScreen extends StatefulWidget {
  final int id;

  const GameScreen({Key? key, required this.id}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late final ConfettiController controller;
  late final FlipCardController controller2;
  late Game game;
  bool _isLoading = false;
  final Random rand = Random();
  final List<String> rounds = <String>[
    "TT - 7 cartas",
    "TE - 8 cartas",
    "EE - 9 cartas",
    "TTT - 10 cartas",
    "TET - 11 cartas",
    "ETE - 12 cartas",
    "EEE - 13 cartas"
  ];

  @override
  void initState() {
    super.initState();
    controller = ConfettiController(duration: const Duration(seconds: 4));
    controller2 = FlipCardController();
    refreshGame();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future refreshGame() async {
    setState(() => _isLoading = true);
    game = await SqlHelper.getGame(widget.id);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _isLoading ? Container() : buildBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Stack(children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(_isLoading
                ? ""
                : game.currentRound == 7
                    ? "Fin"
                    : "Ronda ${game.currentRound + 1}")),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
              _isLoading || game.currentRound == 7
                  ? ""
                  : rounds[game.currentRound],
              style: Theme.of(context).textTheme.bodyText1),
        )
      ]),
    );
  }

  Dismissible buildBody() {
    return Dismissible(
      key: ObjectKey(game.playerList),
      //If the user swipes the card to the right, the round is decremented. If the user swipes the card to the left, the round is incremented.
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart &&
            game.currentRound <= 6) {
          setState(() {
            if (game.currentRound == 6) {
              controller.play();
            }
            setCurrentRound(game.currentRound + 1);
          });
        } else if (direction == DismissDirection.startToEnd &&
            game.currentRound > 0) {
          setState(() {
            setCurrentRound(game.currentRound - 1);
          });
        }
        return Future.value(false);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FlipCardWidget(
            controller: controller2,
            front: Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onLongPress: () async {
                  await controller2.flipCard(rand.nextBool());
                },
                child: game.currentRound == 7 ? endWinner() : cardContent(),
              ),
            ),
            back: Card(
              child: Center(
                child: Flex(direction: Axis.vertical, children: [
                  Expanded(
                    child: SvgPicture.asset("assets/svgs/AL.svg",
                        color: Colors.white, width: 100, fit: BoxFit.scaleDown),
                  )
                ]),
              ),
            )),
      ),
    );
  }

  Padding cardContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: game.playerList!.length,
        itemBuilder: (context, pIndex) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              //Ask for the number of points of the player in the current round.
              onTap: () {
                String input = "";
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            Text("Puntos de ${game.playerList![pIndex].name}"),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            input = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              setState(() {
                                game.playerList![pIndex]
                                        .scores[game.currentRound] =
                                    int.parse(input);
                                SqlHelper.updatePlayer(
                                    game.playerList![pIndex]);
                              });
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              },
              title: Text(game.playerList![pIndex].name),
              subtitle: Text(
                  "Esta ronda: ${getRoundScore(pIndex, game.currentRound)} \tTotal: ${getTotalScore(pIndex)}"),
            ),
          );
        },
      ),
    );
  }

  /// Returns the points of a player ([rIndex]) in the given round ([pIndex]).
  int? getRoundScore(int pIndex, int rIndex) {
    return game.playerList![pIndex].scores[rIndex];
  }

  /// Returns the sum of the points from a given [Player] ([pIndex]) of all previous rounds.
  int? getTotalScore(int pIndex) {
    int? score = 0;
    for (int i = 0; i <= game.currentRound && i != 7; i++) {
      score = score! + game.playerList![pIndex].scores[i]!;
    }
    return score;
  }

  void setCurrentRound(int value) {
    game.currentRound = value;
    SqlHelper.updateGame(game);
    refreshGame();
  }

  Padding endWinner() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConfettiWidget(
                    shouldLoop: false,
                    confettiController: controller,
                    blastDirectionality: BlastDirectionality.explosive,
                  ),
                  SvgPicture.asset("assets/svgs/crown.svg",
                      fit: BoxFit.fitWidth),
                  Text(getWinner(), style: const TextStyle(fontSize: 25)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getWinner() {
    int? min = getTotalScore(0);
    String winner = game.playerList![0].name;
    for (int i = 1; i < game.playerList!.length; i++) {
      if (getTotalScore(i)! < min!) {
        min = getTotalScore(i);
        winner = game.playerList![i].name;
      }
    }
    return winner;
  }
}
