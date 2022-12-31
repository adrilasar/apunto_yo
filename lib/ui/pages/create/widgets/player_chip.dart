import 'package:flutter/material.dart';

import '../../../../data/entities/player.dart';
import '../create_screen.dart';

Dismissible buildPlayerChip(BuildContext context, int index,
    List<Player> playerList, CreateScreenState state) {
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
                    state.refresh(() {
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
      labelPadding: const EdgeInsets.fromLTRB(2, 20, 4, 20),
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
      state.refresh(() {
        playerList.removeAt(index);
      });
    },
  );
}
