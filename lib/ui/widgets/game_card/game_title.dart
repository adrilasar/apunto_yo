import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';

SizedBox buildGameTitle(BuildContext context, Game game) {
  return SizedBox(
    height: 64,
    child: Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(game.title, style: Theme.of(context).textTheme.titleMedium),
      ),
    ),
  );
}
