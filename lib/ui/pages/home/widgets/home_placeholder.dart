import 'package:flutter/material.dart';

import '../../../widgets/place_holder.dart';

Padding buildHomePlaceholder(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: Column(children: [
      Flexible(child: buildPlaceHolder(context)),
      Flexible(child: buildPlaceHolder(context)),
      Flexible(child: buildPlaceHolder(context))
    ]),
  );
}
