import 'package:flutter/material.dart';

class PlayerCount extends StatelessWidget {
  const PlayerCount({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
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
}
