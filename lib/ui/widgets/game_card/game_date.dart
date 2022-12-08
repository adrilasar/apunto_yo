import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';

SizedBox buildGameDate(BuildContext context, Game game) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: getChildren(context, game),
    ),
  );
}

getChildren(BuildContext context, Game game) {
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
