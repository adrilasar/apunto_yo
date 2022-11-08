import 'package:apunto_yo/place_holder.dart';
import 'package:apunto_yo/sql_helper.dart';
import 'package:flutter/material.dart';
import 'game.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  DeleteScreenState createState() => DeleteScreenState();
}

class DeleteScreenState extends State<DeleteScreen> {
  late List<Game> games;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshGames();
  }

  Future refreshGames() async {
    setState(() => _isLoading = true);
    games = await SqlHelper.getDeletedGames();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? buildPlaceHolder() : buildList(context)
    );
  }

  Widget buildList(BuildContext context) {
    if(games.isEmpty) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Papelera', style: Theme.of(context).textTheme.titleLarge,)
            ),
            pinned: true,
            expandedHeight: 120.0
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 260),
                  child: Flex(
                    mainAxisSize: MainAxisSize.min,
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text('No hay partidas borradas',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).textTheme.headlineSmall?.color?.withAlpha(60)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Icon(Icons.delete_outlined, size: 50, color: Theme.of(context).textTheme.headlineSmall?.color?.withAlpha(60),),
                      )
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          )
        ]);
    }
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Papelera', style: Theme.of(context).textTheme.titleLarge,)
          ),
          pinned: true,
          expandedHeight: 120.0
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if(index==0){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 15, 15, 0),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 30,),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text('Las partidas que lleven más de 30 días en la papelera se eliminarán automaticamente.',
                                        style: Theme.of(context).textTheme.bodyMedium),
                            )
                          ),
                        ],
                      )
                    ),
                    const Divider(
                      indent: 10,
                      endIndent: 10,
                      height: 20,
                      thickness: 2,
                    ),
                    buildDeletedCard(games[index], context)
                  ],
                );
              }
              return buildDeletedCard(games[index], context);
            },
            childCount: games.length,
          ),
        ),
      ],
    );
  }
  Padding buildDeletedCard(Game game, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Icon(Icons.restore_from_trash, size: 60),
              content: const Text('¿Seguro que quieres restaurar la partida?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancelar'),
                ),
                OutlinedButton(
                  onPressed: () => {
                    game.dDate = null,
                    SqlHelper.updateGame(game),
                    refreshGames(),
                    Navigator.pop(context, 'Restore')
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 9,
                    children: const [
                      Icon(Icons.restore),
                      Text('Restaurar')
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(game.title, style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ),
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(Icons.circle_outlined, size: 55)
                    ),
                    SizedBox(
                        width: 250,
                        child: GridView.builder(
                            padding: const EdgeInsets.all(0),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: game.playerList?.length ?? 0,
                            gridDelegate: const  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 19,
                                crossAxisCount: 2,
                                mainAxisExtent: 30
                            ),
                            itemBuilder: (BuildContext context, int index){
                              return Card(
                                elevation: 0,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(game.playerList![index].name,
                                        style: Theme.of(context).textTheme.bodyMedium)),
                              );
                            }
                        )
                    )
                  ]
              ),
              //A sized box with creation date and delete date
              SizedBox(
                height: 36,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(getDate(game),
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                            const Icon(Icons.add_circle, size: 18)

                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(Icons.delete_outlined, size: 18),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(getDeleteDate(game),
                                  style: Theme.of(context).textTheme.bodySmall),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//A widget with 3 CardPlaceH widgets
Widget buildPlaceHolder() {
  return CustomScrollView(
    slivers: <Widget>[
      const SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
              title: Text('Papelera')
          ),
          pinned: true,
          expandedHeight: 120.0
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: CardPlaceH(),
              ),
            );
          },
          childCount: 3,
        ),
      ),
    ],
  );
}

String getDate(Game game) {
  String result;
  result = "${game.date.day}/${game.date.month}/${game.date.year}   ${game.date.hour}:${game.date.minute}";
  return result;
}

String getDeleteDate(Game game) {
  String result;
  result = "${game.dDate!.day}/${game.dDate!.month}/${game.dDate!.year}   ${game.dDate!.hour}:${game.dDate!.minute}";
  return result;
}

class CreateBar extends StatelessWidget {

  final double barHeight = 66.0;

  const CreateBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: () {  },
            child: const Text('Iniciar'),
          ),
        ),
      ],
    );
  }
}