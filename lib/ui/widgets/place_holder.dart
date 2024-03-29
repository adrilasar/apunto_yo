import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Padding buildPlaceHolder(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).cardColor.withAlpha(50)
          : Theme.of(context).cardColor.withAlpha(200),
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).cardColor.withAlpha(60)
          : Theme.of(context).cardColor.withAlpha(40),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Container(),
        ),
      ),
    ),
  );
}
