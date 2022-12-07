import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';

class GameTitle extends StatelessWidget {
  final Game game;

  const GameTitle({
    Key? key,
    required this.context, required this.game,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
          Text(game.title, style: Theme
              .of(context)
              .textTheme
              .titleMedium),
        ),
      ),
    );
  }
}