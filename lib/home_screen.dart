import 'package:apunto_yo/game_screen.dart';
import 'package:apunto_yo/place_holder.dart';
import 'package:apunto_yo/rules_screen.dart';
import 'package:apunto_yo/sql_helper.dart';
import 'package:flutter/material.dart';

import 'create_screen.dart';
import 'delete_screen.dart';
import 'game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<Game> games;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshGames();
  }

  Future refreshGames() async {
    setState(() => _isLoading = true);
    games = await SqlHelper.getGames();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Stack(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute(const RulesScreen(), -1, 0))
                            .then((value) => refreshGames());
                      },
                      icon: const Icon(Icons.menu_book_outlined),
                      color: Theme.of(context).disabledColor,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset('assets/launcher_icon/foreground.png', height: 50, width: 50,),
                      Text('Apunto yo!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'RobotoCondensed')),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute(const DeleteScreen(), 1, 0))
                            .then((value) => refreshGames());
                      },
                      icon: const Icon(Icons.auto_delete_outlined),
                      color: Theme.of(context).disabledColor,
                  ))
              ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Inserts the returned Game of the CreateScreen into the database
            Navigator.of(context).push(_createRoute(const CreateScreen(), 0, 1))
                .then((value) => refreshGames());
          },
          label: const Text('Nueva'),
          icon: const Icon(Icons.add),
        ),

        body: _isLoading ? buildPlaceHolder() : buildList(context)
    );
  }

  Padding buildPlaceHolder() {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(children: const [
          Flexible(child: CardPlaceH()),
          Flexible(child: CardPlaceH()),
          Flexible(child: CardPlaceH())
        ]),
      );
  }

  Widget buildList(BuildContext context) {
    if(games.isEmpty) {
      return Center(
        child: Wrap(
          direction: Axis.vertical,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          spacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Crea una partida', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).textTheme.headlineSmall?.color?.withAlpha(60))),
            Icon(Icons.add, size: 50, color: Theme.of(context).textTheme.headlineSmall?.color?.withAlpha(60),)
          ],
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index){
          if(index==0){
            return Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(14, 15, 0, 0),
                      child: Text("Tus partidas", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                  ),
                ),
                createDismissible(index)
              ],
            );
          }
          return createDismissible(index);
        });
  }

  Dismissible createDismissible(index){
    Game deletedItem;

    return Dismissible(
      key: ObjectKey(games[index]),
      background: Container(color: Colors.red, child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 28.0),
            child: Icon(Icons.delete_outline_rounded),
          ),
        ],
      )),
      direction: DismissDirection.endToStart,
      child: buildCard(index),
      onDismissed: (direction){
        setState(() {
          deletedItem = games.removeAt(index);
          deletedItem.dDate = DateTime.now();
          SqlHelper.updateGame(deletedItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('Partida borrada'),
              action: SnackBarAction(
                  textColor: Theme.of(context).bottomAppBarColor,
                  label: 'Deshacer',
                  onPressed: () => setState(() => {
                    games.insert(index, deletedItem),
                    deletedItem.dDate = null,
                    SqlHelper.updateGame(deletedItem),
                    refreshGames()
                  })
              ),
            ),
          );
        });
      },
    );
  }

  Widget buildCard(int gIndex) {
    bool ended = games[gIndex].currentRound == 7;
    int winner = getWinner(gIndex);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: ended ? 1 : 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Navigator.of(context).push(_createRoute(GameScreen(id: games[gIndex].id!), 1, 0))
              .then((value) => refreshGames()),
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(games[gIndex].title, style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ),
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 5),
                        child: Container(
                          width: 65,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(40),
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: Text(games[gIndex].playerList!.length.toString(), style: TextStyle(fontSize: 35, fontFamily: 'RobotoCondensed', color: Theme.of(context).buttonTheme.colorScheme?.primary)),
                        )
                    ),
                    SizedBox(
                        width: 250,
                        child: GridView.builder(
                            padding: const EdgeInsets.all(0),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: games[gIndex].playerList?.length ?? 0,
                            gridDelegate: const  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 19,
                                crossAxisCount: 2,
                                mainAxisExtent: 30
                            ),
                            itemBuilder: (BuildContext context, int index){
                              String pName = games[gIndex].playerList![index].name;
                              return Card(
                                elevation: 0,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(ended && index == winner ? "👑 $pName" : pName,
                                        style: Theme.of(context).textTheme.bodyMedium)),
                              );
                            }
                        )
                    )
                  ]
              ),
              SizedBox(
                height: 36,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(getDate(games[gIndex]),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getDate(Game game) {
    String result;
    result = "${game.date.day}/${game.date.month}/${game.date.year}   "
        "${game.date.hour.toString().padLeft(2, '0')}:"
        "${game.date.minute.toString().padLeft(2, '0')}";
    return result;
  }

  static Route _createRoute(destination, double dx, double dy) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(dx, dy);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Devuelve el index del jugador cuya suma de puntos de todas las rondas es menor
  int getWinner(int gIndex) {
    int winner = 0;
    int min = 0;
    for(int i = 0; i < games[gIndex].playerList!.length; i++){
      int total = 0;
      for(int j = 0; j < games[gIndex].playerList![i].scores.length; j++){
        total += games[gIndex].playerList![i].scores[j]!;
      }
      if(total < min){
        min = total;
        winner = i;
      }
    }
    return winner;
  }
}
