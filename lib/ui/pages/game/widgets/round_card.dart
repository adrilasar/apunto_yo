import 'dart:math';

import 'package:apunto_yo/data/entities/game.dart';
import 'package:apunto_yo/ui/pages/game/widgets/round_content.dart';
import 'package:apunto_yo/ui/pages/game/widgets/winner_content.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../widgets/flip_card.dart';

class RoundCard extends StatefulWidget {
  final Game game;
  final int rIndex;
  final ConfettiController confettiController;

  const RoundCard(
      {Key? key,
      required this.game,
      required this.rIndex,
      required this.confettiController})
      : super(key: key);

  @override
  State<RoundCard> createState() => _RoundCardState();
}

class _RoundCardState extends State<RoundCard> {
  late final FlipCardController controller2;
  final Random rand = Random();

  @override
  void initState() {
    super.initState();
    controller2 = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FlipCardWidget(
          controller: controller2,
          front: Card(
            child: InkWell(
              focusColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              onLongPress: () async {
                await controller2.flipCard(rand.nextBool());
              },
              child: widget.rIndex == 7
                  ? WinnerContent(widget.game,
                      confettiController: widget.confettiController)
                  : RoundContent(widget.rIndex, widget.game),
            ),
          ),
          back: Card(
            child: Center(
              child: Flex(direction: Axis.vertical, children: [
                Expanded(
                  child: SvgPicture.asset("assets/svgs/AL.svg",
                      color: Colors.white, width: 100, fit: BoxFit.scaleDown),
                )
              ]),
            ),
          )),
    );
  }
}
