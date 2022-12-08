import 'package:apunto_yo/ui/pages/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../../../helper/router.dart';
import '../../create/create_screen.dart';

FloatingActionButton buildCreateButton(
    BuildContext context, HomeScreenState state) {
  return FloatingActionButton.extended(
    onPressed: () {
      //Inserts the returned Game of the CreateScreen into the database
      Navigator.of(context)
          .push(RouteCreator(
              CreateScreen(refreshGames: state.refreshGames), 0, 1))
          .then((value) => state.refreshGames());
    },
    label: const Text('Crear'),
    icon: const Icon(Icons.add),
  );
}
