import 'dart:math';

import 'package:apunto_yo/ui/pages/home/home_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sets the value of the given [step] to `true`.
/// If all steps are `true`, the dialog is shown.
checkSteps(BuildContext context, int step, ConfettiController controller,
    HomeScreenState state) {
  if (step == 0) {
    state.refresh(() => state.s1 = true);
  } else if (step == 1) {
    state.refresh(() => state.s2 = true);
  }
  if (state.s1 && state.s2) {
    state.refresh(() => {state.s1 = state.s2 = false, controller.play()});
    showDialog(
      context: context,
      builder: (BuildContext context) => getStepsDialog(context, controller),
    );
  }
}

AlertDialog getStepsDialog(
    BuildContext context, ConfettiController controller) {
  HapticFeedback.lightImpact()
      .then((value) => HapticFeedback.heavyImpact())
      .then((value) => HapticFeedback.lightImpact());
  return AlertDialog(
    title: const Text(
      '¡ Felicidades ! 🐣',
    ),
    content: const Text(
        'Has encontrado el menú oculto.\n\n¡Eres un auténtico campeón en perder el tiempo!'),
    actions: <Widget>[
      ConfettiWidget(
        shouldLoop: false,
        confettiController: controller,
        blastDirectionality: BlastDirectionality.directional,
        blastDirection: 52 * pi / 36,
        minBlastForce: 40,
        maxBlastForce: 70,
      ),
      TextButton(
        child: const Text(
          'Volver',
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}
