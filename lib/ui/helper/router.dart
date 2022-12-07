import 'package:flutter/material.dart';

class RouteCreator extends PageRouteBuilder {
  final Widget destination;
  final double dx;
  final double dy;

  RouteCreator(this.destination, this.dx, this.dy)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(dx, dy);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
