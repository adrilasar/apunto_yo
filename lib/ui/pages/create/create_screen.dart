import 'dart:math';

import 'package:apunto_yo/data/entities/player.dart';
import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/helper/router.dart';
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

  SliverGrid buildBody() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: index % 2 == 0
              ? const EdgeInsets.only(left: 25)
              : const EdgeInsets.only(right: 25),
          child: buildPlayerChip(index),
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

  ActionChip buildAddButton(BuildContext context) {
    return ActionChip(
      side: BorderSide.none,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            playerNameController.clear();
            return buildAddDialog(context);
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
              fontSize: Theme.of(context).textTheme.button?.fontSize)),
      elevation: 12,
    );
  }

  AlertDialog buildAddDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir jugador'),
      content: TextField(
        maxLength: 14,
        autofocus: true,
        controller: playerNameController,
        decoration: const InputDecoration(
          hintText: 'Nombre del jugador',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        //Adds the player to the list if is not already in it
        TextButton(
          onPressed: () {
            //Adds a player to the list if its name is not empty and is not already in the list
            if (playerNameController.text.isNotEmpty &&
                !playerList.any(
                    (player) => player.name == playerNameController.text)) {
              setState(() {
                playerList.add(Player(name: playerNameController.text));
              });
            }
            Navigator.of(context).pop();
          },
          child: const Text('Añadir'),
        ),
      ],
    );
  }

  Dismissible buildPlayerChip(int index) {
    return Dismissible(
      key: ObjectKey(playerList[index]),
      child: ActionChip(
        side: BorderSide.none,
        shape: const StadiumBorder(),
        //Ask for confirmation before deleting the player
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Eliminar jugador'),
                content: Text(
                    '¿Estás seguro de que quieres eliminar a ${playerList[index].name}?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        playerList.removeAt(index);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Eliminar'),
                  ),
                ],
              );
            },
          );
        },
        labelPadding: const EdgeInsets.fromLTRB(10, 20, 30, 20),
        avatar: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(40),
              color: Theme.of(context).scaffoldBackgroundColor),
          child: Text(playerList[index].name.characters.first,
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'RobotoCondensed',
                  color: Theme.of(context).buttonTheme.colorScheme?.primary)),
        ),
        label: Text(playerList[index].name),
        elevation: 8,
      ),
      onDismissed: (direction) {
        setState(() {
          playerList.removeAt(index);
        });
      },
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

    saveGameToDatabase(game).then((value) => Navigator.of(context)
        .pushReplacement(RouteCreator(GameScreen(id: value), 1, 0))
        .then((value) => widget.refreshGames()));
  }

  Future<int> saveGameToDatabase(Game game) async {
    int id = await SqlHelper.createGame(game);
    //Inserts each player of the game into the database
    if (game.playerList != null) {
      for (Player player in game.playerList!) {
        await SqlHelper.createPlayer(player.copy(gId: id));
      }
    }
    return id;
  }
}
