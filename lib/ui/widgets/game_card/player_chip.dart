import 'package:flutter/material.dart';

Card buildPlayerChip(BuildContext context, bool isWinner, String pName) {
  return Card(
    elevation: 0,
    child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(isWinner ? "👑  $pName" : pName,
              style: Theme.of(context).textTheme.bodyMedium),
        )),
  );
}
