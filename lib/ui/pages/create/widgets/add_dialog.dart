import 'package:flutter/material.dart';

import '../../../../data/entities/player.dart';
import '../create_screen.dart';

AlertDialog buildAddDialog(
    BuildContext context,
    TextEditingController playerNameController,
    List<Player> playerList,
    CreateScreenState state) {
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
              !playerList
                  .any((player) => player.name == playerNameController.text)) {
            state.refresh(() {
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
