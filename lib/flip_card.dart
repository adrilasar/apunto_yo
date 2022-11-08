import 'dart:math';

import 'package:flutter/material.dart';

class FlipCardController{
  FlipCardWidgetState? _state;
  Future flipCard(r) async => _state?.flipCard(r);
}

class FlipCardWidget extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipCardController controller;

  const FlipCardWidget({
    required this.controller,
    required this.front,
    required this.back,
    Key? key
  }) : super(key: key);

  @override
  FlipCardWidgetState createState() => FlipCardWidgetState();
}

class FlipCardWidgetState extends State<FlipCardWidget>
    with TickerProviderStateMixin{
  late AnimationController controller;
  bool random = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    widget.controller._state = this;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> flipCard(r) async {
    try {
      random = r;
      await controller.forward(from: 0).orCancel;
      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      final angle = controller.value * -pi;
      final transform = randomTransform(angle);
      return Transform(
        transform: transform,
        alignment: Alignment.center,
        child: isFrontWidget(angle.abs())
            ? widget.front
            : Transform(
          transform: Matrix4.identity()..rotateY(pi),
          alignment: Alignment.center,
          child: widget.back,
        ),
      );
    },
  );

  Matrix4 randomTransform(double angle) {
    if (random) {
      return Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(angle);
    }
    return Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle);
  }

  isFrontWidget(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;

    return angle <= degrees90 || angle >= degrees270;
  }
}