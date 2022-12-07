import 'package:flutter/material.dart';

import '../../../widgets/place_holder.dart';

class HomePlaceHolder extends StatelessWidget {
  const HomePlaceHolder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(children: const [
        Flexible(child: PlaceHolder()),
        Flexible(child: PlaceHolder()),
        Flexible(child: PlaceHolder())
      ]),
    );
  }
}
