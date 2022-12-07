import 'package:apunto_yo/ui/widgets/game_card/player_chip.dart';
import 'package:flutter/material.dart';

import '../../../data/entities/player.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({
    Key? key,
    required this.players,
    required this.winner,
  }) : super(key: key);

  final List<Player> players;
  final int winner;

  @override
  Widget build(BuildContext context) {
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
              return PlayerChip(isWinner: index == winner, pName: pName);
            }));
  }
}
