import 'package:flutter/material.dart';

import '../../data/entities/game.dart';
import 'game_card/game_date.dart';
import 'game_card/game_title.dart';
import 'game_card/player_count.dart';
import 'game_card/player_list.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({
    Key? key,
    required this.context,
    required this.game,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTitle(
          game: game,
          context: context,
        ),
        Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            children: [
              PlayerCount(count: game.playerList!.length),
              PlayerList(players: game.playerList!, winner: game.getWinner()),
            ]),
        GameDate(context: context, game: game),
      ],
    );
  }
}
