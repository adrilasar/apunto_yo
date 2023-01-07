import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/helper/router.dart';
import 'package:apunto_yo/ui/pages/home/widgets/create_button.dart';
import 'package:apunto_yo/ui/pages/home/widgets/home_game_card.dart';
import 'package:apunto_yo/ui/pages/home/widgets/home_placeholder.dart';
import 'package:apunto_yo/ui/pages/home/widgets/steps_dialog.dart';
import 'package:apunto_yo/ui/pages/rules/rules_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';
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

  refresh(VoidCallback callback) {
    setState(() {
      callback();
    });
  }

  Future refreshGames() async {
    setState(() => _isLoading = true);
    games = await SqlHelper.getGames();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        floatingActionButton: buildCreateButton(context, this),
        body: _isLoading ? buildHomePlaceholder(context) : buildBody(context));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Stack(
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
                getTitle(),
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
      ),
    );
  }

  Widget buildBody(BuildContext context) {
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
                buildHomeGameCard(context, index, games, this)
              ],
            );
          }
          return buildHomeGameCard(context, index, games, this);
        });
  }

  Widget getTitle() {
    return GestureDetector(
      onLongPress: () => checkSteps(context, 0, controller, this),
      onDoubleTap: () => checkSteps(context, 1, controller, this),
      child: Text(
        "Apunto Yo!",
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontFamily: 'RobotoCondensed'),
      ),
    );
  }
}
