import 'package:flutter/material.dart';

class PlayerChip extends StatelessWidget {
  const PlayerChip({
    Key? key,
    required this.isWinner,
    required this.pName,
  }) : super(key: key);

  final bool isWinner;
  final String pName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Align(
          alignment: Alignment.center,
          child: Text(isWinner ? "👑 $pName" : pName,
              style: Theme.of(context).textTheme.bodyMedium)),
    );
  }
}
