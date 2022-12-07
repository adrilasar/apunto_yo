import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/pages/delete/widgets/delete_placeholder.dart';
import 'package:apunto_yo/ui/widgets/game_card.dart';
import 'package:flutter/material.dart';

import '../../../data/entities/game.dart';

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
        body: _isLoading ? const DeletePlaceHolder() : buildList(context));
  }

  Widget buildList(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
              'Papelera',
              style: Theme.of(context).textTheme.titleLarge,
            )),
            pinned: true,
            expandedHeight: 120.0),
        SliverList(
          delegate: games.isEmpty ? buildEmptyBody() : buildBody(),
        ),
      ],
    );
  }

  SliverChildBuilderDelegate buildBody() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(14, 15, 15, 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        size: 30,
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                            'Las partidas que lleven más de 30 días en la papelera se eliminarán automaticamente.',
                            style: Theme.of(context).textTheme.bodyMedium),
                      )),
                    ],
                  )),
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
    );
  }

  SliverChildBuilderDelegate buildEmptyBody() {
    return SliverChildBuilderDelegate(
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
                child: Text(
                  'No hay partidas borradas',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.color
                          ?.withAlpha(60)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Icon(
                  Icons.delete_outlined,
                  size: 50,
                  color: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.color
                      ?.withAlpha(60),
                ),
              )
            ],
          ),
        );
      },
      childCount: 1,
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
                    children: const [Icon(Icons.restore), Text('Restaurar')],
                  ),
                ),
              ],
            ),
          ),
          child: GameCard(context: context, game: game),
        ),
      ),
    );
  }
}
