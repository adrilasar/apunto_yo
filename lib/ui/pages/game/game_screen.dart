import 'dart:math';

import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/pages/game/widgets/game_app_bar.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/entities/game.dart';
import '../../../data/entities/player.dart';
import '../../widgets/flip_card.dart';

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
      appBar: !_isLoading ? buildAppBar(context, game.currentRound) : AppBar(),
      body: !_isLoading ? buildBody() : Container(),
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
      child: buildCard(),
    );
  }

  Padding buildCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FlipCardWidget(
          controller: controller2,
          front: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onLongPress: () async {
                await controller2.flipCard(rand.nextBool());
              },
              child: game.currentRound == 7 ? winnerCard() : roundCard(),
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
    );
  }

  Padding roundCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: game.playerList!.length,
        itemBuilder: (context, pIndex) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: buildPlayerInfo(context, game.playerList![pIndex]),
          );
        },
      ),
    );
  }

  ListTile buildPlayerInfo(BuildContext context, Player player) {
    return ListTile(
      //Ask for the number of points of the player in the current round.
      onTap: () {
        String input = "";
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Puntos de ${player.name}"),
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
                        player.scores[game.currentRound] = int.parse(input);
                        SqlHelper.updatePlayer(player);
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      title: Text(player.name),
      subtitle: Text(
          "Esta ronda: ${player.getRoundScore(game.currentRound)} \tTotal: ${player.getTotalScore()}"),
    );
  }

  void setCurrentRound(int value) {
    game.currentRound = value;
    SqlHelper.updateGame(game);
    refreshGame();
  }

  Padding winnerCard() {
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
                  Text(game.playerList![game.getWinner()].name,
                      style: const TextStyle(fontSize: 25)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
