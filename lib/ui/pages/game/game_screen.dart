import 'dart:math';

import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/pages/game/widgets/game_app_bar.dart';
import 'package:apunto_yo/ui/pages/game/widgets/round_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';

class GameScreen extends StatefulWidget {
  final int id;

  const GameScreen({Key? key, required this.id}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late final ConfettiController _confettiController;
  late final CarouselController _carouselController;
  late Game game;
  bool _isLoading = false;
  final Random rand = Random();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    _carouselController = CarouselController();
    refreshGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void refreshGame() async {
    setState(() => _isLoading = true);
    game = await SqlHelper.getGame(widget.id);
    setState(() => _isLoading = false);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _carouselController.jumpToPage(game.currentRound));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_isLoading ? buildAppBar(context, game.currentRound) : AppBar(),
      body: !_isLoading ? buildBody() : Container(),
      bottomNavigationBar: !_isLoading ? buildBottomBar() : Container(),
    );
  }

  Widget buildBody() {
    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          if (index == 7) {
            _confettiController.play();
          }
          setState(() => game.currentRound = index);
          SqlHelper.updateGame(game);
        },
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
      ),
      items: List.generate(
          8,
          (index) => RoundCard(
              game: game,
              rIndex: index,
              confettiController: index == 7 ? _confettiController : null)),
    );
  }

  buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        8,
        (index) => Container(
          width: index == game.currentRound ? 14.0 : 11.0,
          height: 7.0,
          margin: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 3.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            // If the round is the current one, make it primary color, if it's the last one, make it green, else make it grey
            color: getColor(index),
          ),
        ),
      ),
    );
  }

  Color? getColor(int index) {
    if (index == game.currentRound) {
      return index == 7
          ? Colors.purple.withAlpha(200)
          : Theme.of(context).buttonTheme.colorScheme?.primary.withAlpha(200);
    } else if (index == 7) {
      return Colors.purple.withAlpha(90);
    } else {
      return Colors.grey.withAlpha(90);
    }
  }
}
