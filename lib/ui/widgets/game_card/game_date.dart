import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';

class GameDate extends StatelessWidget {
  final Game game;

  const GameDate({
    Key? key,
    required this.context,
    required this.game,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getChildren(game),
      ),
    );
  }

  getChildren(Game game) {
    bool isDeleted = game.dDate != null;

    if (isDeleted) {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.delete_outlined, size: 18),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(game.getDeleteDate(),
                        style: Theme.of(context).textTheme.bodySmall),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(game.getDate(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Icon(Icons.add_circle, size: 18)
                ],
              ),
            )
          ],
        ),
      );
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(game.getDate(), style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
