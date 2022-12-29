import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../data/entities/game.dart';

class WinnerContent extends StatefulWidget {
  final Game game;
  final ConfettiController confettiController;

  const WinnerContent(this.game, {Key? key, required this.confettiController})
      : super(key: key);

  @override
  State<WinnerContent> createState() => _WinnerContentState();
}

class _WinnerContentState extends State<WinnerContent> {
  late final ConfettiController controller;
  late final Game game;

  @override
  void initState() {
    super.initState();
    controller = widget.confettiController;
    game = widget.game;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConfettiWidget(
                    shouldLoop: false,
                    confettiController: controller,
                    blastDirectionality: BlastDirectionality.explosive,
                  ),
                  SvgPicture.asset("assets/svgs/crown.svg",
                      fit: BoxFit.fitWidth),
                  Text(
                      game
                          .playerList![
                      game.getWinner() != -1 ? game.getWinner() : 0]
                          .name,
                      style: const TextStyle(fontSize: 25)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
