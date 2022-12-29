import 'package:flutter/material.dart';

const List<int> cards = <int>[7, 8, 9, 10, 11, 12, 13];

const List<String> objectives = <String>[
  "2 Tríos",
  "Trío y Escalera",
  "2 Escaleras",
  "3 Tríos",
  "2 Tríos y Escalera",
  "Trío y 2 Escaleras",
  "3 Escaleras",
];

AppBar buildAppBar(BuildContext context, int currentRound) {
  return AppBar(
    title: Stack(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text(currentRound == 7 ? "Fin" : "Ronda ${currentRound + 1}")),
      Align(
        alignment: Alignment.centerRight,
        child: currentRound == 7 ? null : buildInfo(currentRound, context),
      )
    ]),
  );
}

Widget buildInfo(int currentRound, BuildContext context) {
  // Returns an info icon that shows a tooltip with the round description
  return Tooltip(
    triggerMode: TooltipTriggerMode.tap,
    showDuration: const Duration(seconds: 4),
    message: """
Objetivo: ${objectives[currentRound]}
Nº de Cartas: ${cards[currentRound]}""",
    child: const Icon(Icons.info_outline_rounded),
  );
}
