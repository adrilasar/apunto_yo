import 'package:flutter/material.dart';

Widget buildPlayerCount(BuildContext context, int count) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 5),
      child: Container(
        width: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(40),
            color: Theme.of(context).scaffoldBackgroundColor),
        child: Text(count.toString(),
            style: TextStyle(
                fontSize: 35,
                fontFamily: 'RobotoCondensed',
                color: Theme.of(context).buttonTheme.colorScheme?.primary)),
      ));
}
