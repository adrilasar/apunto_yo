import 'package:apunto_yo/data/sql_helper.dart';
import 'package:apunto_yo/ui/pages/delete/widgets/delete_placeholder.dart';
import 'package:apunto_yo/ui/pages/delete/widgets/deleted_card.dart';
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
        body: _isLoading ? buildDeletePlaceholder() : buildList(context));
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
              buildDeletedCard(context, games[index], this)
            ],
          );
        }
        return buildDeletedCard(context, games[index], this);
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
}
