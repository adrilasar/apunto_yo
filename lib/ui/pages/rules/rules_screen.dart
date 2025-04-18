import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  RulesScreenState createState() => RulesScreenState();
}

class RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
              title: Text(
            "Normas",
            style: Theme.of(context).textTheme.titleLarge,
          )),
          pinned: true,
          expandedHeight: 120.0),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return buildBody(context);
          },
          childCount: 1,
        ),
      )
    ]));
  }

  Padding buildBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Tipo de baraja:\n\n",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: "Dos barajas inglesas, con 2 o 3 comodines por baraja.\n",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: "(También se admiten las de póker españolas)\n\n\n",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: "Valor de las cartas:\n\n",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: "• Comodín o jóker: 50p.\n"
                    "• As: 20p.\n"
                    "• Figuras (rey, reina o dama y jota): 10p.\n"
                    "• Cartas de 2 a 10: Su valor numérico\n\n\n",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: "Objetivo y cartas a repartir por ronda:\n\n",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: "1ª ➜ 2 Tríos  -  7 cartas\n"
                    "2ª ➜ Trío y Escalera  -  8 cartas\n"
                    "3ª ➜ 2 Escaleras  -  9 cartas\n"
                    "4ª ➜ 3 Tríos  -  10 cartas\n"
                    "5ª ➜ 2 Tríos y Escalera  -  11 cartas\n"
                    "6ª ➜ Trío y 2 Escaleras  -  12 cartas\n"
                    "7ª ➜ 3 Escaleras  -  13 cartas\n\n\n",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: "Final del juego o mano:\n\n",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: "Cuando un jugador...\n"
                    "• Se baja y cierra en el mismo turno ➜ -10p.\n"
                    "• Se bajó en un turno anterior ➜ 0p.\n\n\n",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // Centered text
              const TextSpan(
                text: "Fuente: www.continental.org.es",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ])),
          ),
        ));
  }
}
