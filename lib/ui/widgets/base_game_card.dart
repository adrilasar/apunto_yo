import 'package:flutter/material.dart';

import '../../data/entities/game.dart';
import 'game_card/game_date.dart';
import 'game_card/game_title.dart';
import 'game_card/player_count.dart';
import 'game_card/player_list.dart';

Column buildBaseGameCard(BuildContext context, Game game) {
  return Column(
    children: [
      buildGameTitle(context, game),
      ListTile(
        leading: buildPlayerCount(context, game.playerList!.length),
        title: buildPlayerList(context, game.playerList!, game.getWinner()),
      ),
      buildGameDate(context, game),
    ],
  );
}
