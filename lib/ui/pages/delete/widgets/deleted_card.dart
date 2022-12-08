import 'package:flutter/material.dart';

import '../../../../data/entities/game.dart';
import '../../../../data/sql_helper.dart';
import '../../../widgets/base_game_card.dart';
import '../delete_screen.dart';

Padding buildDeletedCard(
    BuildContext context, Game game, DeleteScreenState state) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Icon(Icons.restore_from_trash, size: 60),
            content: const Text('¿Seguro que quieres restaurar la partida?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancelar'),
              ),
              OutlinedButton(
                onPressed: () => {
                  game.dDate = null,
                  SqlHelper.updateGame(game),
                  state.refreshGames(),
                  Navigator.pop(context, 'Restore')
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 9,
                  children: const [Icon(Icons.restore), Text('Restaurar')],
                ),
              ),
            ],
          ),
        ),
        child: buildBaseGameCard(context, game),
      ),
    ),
  );
}
