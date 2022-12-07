import 'package:flutter/material.dart';

const List<String> rounds = <String>[
  "TT - 7 cartas",
  "TE - 8 cartas",
  "EE - 9 cartas",
  "TTT - 10 cartas",
  "TET - 11 cartas",
  "ETE - 12 cartas",
  "EEE - 13 cartas"
];

AppBar buildAppBar(BuildContext context, int currentRound) {
  return AppBar(
    title: Stack(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text(currentRound == 7 ? "Fin" : "Ronda ${currentRound + 1}")),
      Align(
        alignment: Alignment.centerRight,
        child: currentRound == 7 ? null : RoundInfo(currentRound: currentRound),
      )
    ]),
  );
}

class RoundInfo extends StatelessWidget {
  final int currentRound;

  const RoundInfo({
    Key? key,
    required this.currentRound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(rounds[currentRound],
        style: Theme.of(context).textTheme.bodyText1);
  }
}
