import 'dart:math';

import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/helper/router.dart';
import 'package:apunto_yo/ui/pages/game/game_screen.dart';
import 'package:apunto_yo/ui/pages/home/widgets/home_placeholder.dart';
import 'package:apunto_yo/ui/pages/rules/rules_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/entities/game.dart';
import '../../widgets/game_card.dart';
import '../create/create_screen.dart';
import '../delete/delete_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<Game> games;
  bool _isLoading = false;
  late final ConfettiController controller;
  bool s1 = false;
  bool s2 = false;

  @override
  void initState() {
    super.initState();
    controller = ConfettiController(duration: const Duration(seconds: 4));
    refreshGames();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future refreshGames() async {
    setState(() => _isLoading = true);
    games = await SqlHelper.getGames();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: buildTitle(context),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Inserts the returned Game of the CreateScreen into the database
            Navigator.of(context)
                .push(RouteCreator(
                    CreateScreen(refreshGames: refreshGames), 0, 1))
                .then((value) => refreshGames());
          },
          label: const Text('Nueva'),
          icon: const Icon(Icons.add),
        ),
        body: _isLoading ? const HomePlaceHolder() : buildList(context));
  }

  Stack buildTitle(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(RouteCreator(const RulesScreen(), -1, 0))
                    .then((value) => refreshGames());
              },
              icon: const Icon(Icons.menu_book_outlined),
              color: Theme.of(context).disabledColor,
            )),
        Align(
          alignment: Alignment.center,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(
                'assets/launcher_icon/foreground.png',
                height: 50,
                width: 50,
              ),
              buildAppTitle(),
            ],
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(RouteCreator(const DeleteScreen(), 1, 0))
                    .then((value) => refreshGames());
              },
              icon: const Icon(Icons.auto_delete_outlined),
              color: Theme.of(context).disabledColor,
            ))
      ],
    );
  }

  Widget buildList(BuildContext context) {
    if (games.isEmpty) {
      return Center(
        child: Wrap(
          direction: Axis.vertical,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Crea una partida',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.color
                        ?.withAlpha(60))),
            Icon(Icons.add,
                size: 50,
                color: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.color
                    ?.withAlpha(60))
          ],
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(14, 15, 0, 0),
                      child: Text("Tus partidas",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold))),
                ),
                createDismissible(index)
              ],
            );
          }
          return createDismissible(index);
        });
  }

  Dismissible createDismissible(index) {
    Game deletedItem;

    return Dismissible(
      key: ObjectKey(games[index]),
      background: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 28.0),
                child: Icon(Icons.delete_outline_rounded),
              ),
            ],
          )),
      direction: DismissDirection.endToStart,
      child: buildCard(games[index]),
      onDismissed: (direction) {
        setState(() {
          deletedItem = games.removeAt(index);
          deletedItem.dDate = DateTime.now();
          SqlHelper.updateGame(deletedItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('Partida borrada'),
              action: SnackBarAction(
                  textColor: Theme.of(context).bottomAppBarColor,
                  label: 'Deshacer',
                  onPressed: () => setState(() => {
                        games.insert(index, deletedItem),
                        deletedItem.dDate = null,
                        SqlHelper.updateGame(deletedItem),
                        refreshGames()
                      })),
            ),
          );
        });
      },
    );
  }

  Widget buildCard(Game game) {
    bool ended = game.currentRound == 7;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: ended ? 1 : 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.of(context)
              .push(RouteCreator(GameScreen(id: game.id!), 1, 0))
              .then((value) => refreshGames()),
          child: GameCard(context: context, game: game),
        ),
      ),
    );
  }

  Widget buildAppTitle() {
    return GestureDetector(
      onLongPress: () => checkSteps(0),
      onDoubleTap: () => checkSteps(1),
      child: Text(
        "Apunto yo!",
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontFamily: 'RobotoCondensed'),
      ),
    );
  }

  Widget getStepsDialog() {
    HapticFeedback.lightImpact()
        .then((value) => HapticFeedback.heavyImpact())
        .then((value) => HapticFeedback.lightImpact());
    return AlertDialog(
      title: const Text(
        '¡ Felicidades ! 🐣',
      ),
      content: const Text(
          'Has encontrado el menú oculto.\n\n¡Eres un auténtico campeón en perder el tiempo!'),
      actions: <Widget>[
        ConfettiWidget(
          shouldLoop: false,
          confettiController: controller,
          blastDirectionality: BlastDirectionality.directional,
          blastDirection: 52 * pi / 36,
          minBlastForce: 40,
          maxBlastForce: 70,
        ),
        TextButton(
          child: const Text(
            'Volver',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  /// Sets the value of the given [step] to `true`.
  /// If all steps are `true`, the dialog is shown.
  checkSteps(int step) {
    if (step == 0) {
      setState(() => s1 = true);
    } else if (step == 1) {
      setState(() => s2 = true);
    }
    if (s1 && s2) {
      setState(() => {s1 = s2 = false, controller.play()});
      showDialog(
        context: context,
        builder: (BuildContext context) => getStepsDialog(),
      );
    }
  }
}
