import 'package:flutter/material.dart';

import '../../../../data/entities/game.dart';
import '../../../../data/sql_helper.dart';
import '../../../helper/router.dart';
import '../../../widgets/base_game_card.dart';
import '../../game/game_screen.dart';
import '../home_screen.dart';

Dismissible buildHomeGameCard(
    BuildContext context, index, List<Game> games, HomeScreenState state) {
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
    child: buildCardContent(context, games[index], state),
    onDismissed: (direction) {
      cardDismissed(context, index, games, state);
    },
  );
}

Widget buildCardContent(
    BuildContext context, Game game, HomeScreenState state) {
  bool ended = game.currentRound == 7;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: ended ? 1 : 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.of(context)
            .push(RouteCreator(GameScreen(id: game.id!), 1, 0))
            .then((value) => state.refreshGames()),
        child: buildBaseGameCard(context, game),
      ),
    ),
  );
}

cardDismissed(
    BuildContext context, int index, List<Game> games, HomeScreenState state) {
  Game deletedItem;

  state.refresh(() {
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
            onPressed: () => state.refresh(() => {
                  games.insert(index, deletedItem),
                  deletedItem.dDate = null,
                  SqlHelper.updateGame(deletedItem),
                  state.refreshGames()
                })),
      ),
    );
  });
}
