import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'ui/app_theme.dart';
import 'ui/pages/home/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
      return MaterialApp(
        title: 'Apunto yo!',
        theme: AppTheme.lightTheme(lightColorScheme),
        darkTheme: AppTheme.darkTheme(darkColorScheme),
        home: const HomeScreen(),
      );
    });
  }
}
