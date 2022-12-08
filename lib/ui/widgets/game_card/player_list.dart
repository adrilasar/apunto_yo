import 'package:apunto_yo/ui/widgets/game_card/player_chip.dart';
import 'package:flutter/material.dart';

import '../../../data/entities/player.dart';

Widget buildPlayerList(BuildContext context, List<Player> players, int winner) {
  return SizedBox(
      width: 250,
      child: GridView.builder(
          padding: const EdgeInsets.all(0),
          primary: false,
          shrinkWrap: true,
          itemCount: players.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 19, crossAxisCount: 2, mainAxisExtent: 30),
          itemBuilder: (BuildContext context, int index) {
            String pName = players[index].name;
            return buildPlayerChip(context, index == winner, pName);
          }));
}
