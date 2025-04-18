import 'dart:math';

import 'package:apunto_yo/data/entities/player.dart';
import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/helper/router.dart';
import 'package:apunto_yo/ui/pages/create/widgets/add_dialog.dart';
import 'package:apunto_yo/ui/pages/create/widgets/player_chip.dart';
import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';
import '../game/game_screen.dart';

class CreateScreen extends StatefulWidget {
  final Function refreshGames;

  const CreateScreen({super.key, required this.refreshGames});

  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  List<Player> playerList = [];
  TextEditingController playerNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  refresh(VoidCallback callback) {
    setState(callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          buildAppBar(context),
          playerList.isEmpty ? buildEmptyBody(context) : buildBody(),
        ],
      ),
      floatingActionButton: buildAddButton(context),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: buildPlayButton(context),
          ),
        ],
      ),
      pinned: true,
      expandedHeight: 120.0,
      flexibleSpace: buildTitleTextField(),
    );
  }

  SliverGrid buildBody() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: index % 2 == 0
              ? const EdgeInsets.only(left: 25)
              : const EdgeInsets.only(right: 25),
          child: buildPlayerChip(context, index, playerList, this),
        );
      }, childCount: playerList.length),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }

  SliverToBoxAdapter buildEmptyBody(BuildContext context) {
    return SliverToBoxAdapter(
        child: Center(
      heightFactor: 5,
      child: Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Añade los jugadores',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.color
                      ?.withAlpha(60))),
          Icon(
            Icons.add_reaction_outlined,
            size: 50,
            color:
                Theme.of(context).textTheme.headlineSmall?.color?.withAlpha(60),
          )
        ],
      ),
    ));
  }

  FloatingActionButton buildPlayButton(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        if (playerList.isNotEmpty) {
          createGame();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No hay jugadores"),
            ),
          );
        }
      },
      elevation: 1,
      child: const Icon(Icons.play_arrow),
    );
  }

  FlexibleSpaceBar buildTitleTextField() {
    return FlexibleSpaceBar(
        title: SizedBox(
      height: 48,
      width: 160,
      child: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Escribe un título"),
          controller: titleController),
    ));
  }

  ActionChip buildAddButton(BuildContext context) {
    return ActionChip(
      side: BorderSide.none,
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showDialog(
          context: context,
          builder: (context) {
            playerNameController.clear();
            return buildAddDialog(
                context, playerNameController, playerList, this);
          },
        );
      },
      shape: const StadiumBorder(),
      labelPadding: const EdgeInsets.fromLTRB(5, 13, 11, 13),
      avatar: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(40),
            color: Theme.of(context).scaffoldBackgroundColor),
        child: const Icon(Icons.add_reaction_outlined, size: 20),
      ),
      label: Text('Añadir jugador',
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize)),
      elevation: 12,
    );
  }

  void createGame() {
    Game game = Game(
      title: titleController.text,
      playerList: playerList,
      date: DateTime.now(),
      random: Random().nextInt(100),
      currentRound: 0,
    );

    SqlHelper.saveGameToDatabase(game).then((value) {
      Navigator.of(context)
          .pushReplacement(RouteCreator(GameScreen(id: value), 1, 0))
          .then((value) => widget.refreshGames());
    });
  }
}
