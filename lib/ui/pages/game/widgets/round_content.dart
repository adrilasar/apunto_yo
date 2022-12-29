import 'package:apunto_yo/data/sql_helper.dart';
import 'package:flutter/material.dart';

import '../../../../data/entities/game.dart';
import '../../../../data/entities/player.dart';

class RoundContent extends StatefulWidget {
  final int rIndex;
  final Game game;

  const RoundContent(this.rIndex, this.game, {Key? key}) : super(key: key);

  @override
  State<RoundContent> createState() => _RoundContentState();
}

class _RoundContentState extends State<RoundContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(155, 0, 0, 30),
            child: Wrap(
              spacing: 40,
              children: [
                Text(
                  'Esta ronda',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'TOTAL',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.game.playerList!.length,
              itemBuilder: (context, pIndex) {
                return Wrap(
                  children: [
                    buildPlayerInfo(context, widget.rIndex,
                        widget.game.playerList![pIndex]),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Divider(),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildPlayerInfo(BuildContext context, int rIndex, Player player) {
    return ListTile(
      leading: SizedBox(
        width: 120,
        child: Text(
          player.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      title: TextFormField(
        initialValue: player.scores[rIndex] != 0
            ? player.scores[rIndex].toString()
            : null,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.titleLarge,
        decoration: const InputDecoration(
          hintText: '0',
        ),
        onChanged: (value) {
          player.scores[rIndex] = int.tryParse(value) ?? 0;
          SqlHelper.updatePlayer(player);
        },
      ),
      trailing: SizedBox(
        width: 40,
        child: Text(
          player.getTotalScore().toString(),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
