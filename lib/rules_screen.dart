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
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                    title: Text("Normas", style: Theme.of(context).textTheme.titleLarge,)
                ),
                pinned: true,
                expandedHeight: 120.0
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(25),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Tipo de baraja:\n\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: "Dos barajas inglesas, con 2 o 3 comodines por baraja. (También se admiten las de póker españolas)\n\n\n",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "Valor de las cartas:\n\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: "Comodín o jóker: 50 puntos\n"
                                "As: 20 puntos\n"
                                "Figuras (rey, reina o dama y jota): 10 puntos\n"
                                "Cartas de 2 a 10: Su valor numérico\n\n\n",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "Objetivo y cartas a repartir por ronda:\n\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: "1ª (TT): Dos tríos. 7 cartas.\n"
                                "2ª (TE): Un trío y una escalera. 8 cartas.\n"
                                "3ª (EE): Dos escaleras. 9 cartas.\n"
                                "4ª (TTT): Tres tríos. 10 cartas.\n"
                                "5ª (TET): Dos tríos y una escalera. 11 cartas.\n"
                                "6ª (ETE): Un trío y dos escaleras. 12 cartas.\n"
                                "7ª (EEE): Tres escaleras. 13 cartas.\n\n\n",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          // Centered text
                          const TextSpan(
                            text: "(www.continental.org.es)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          ]
                      )));
                },
                childCount: 1,
              ),
            )
          ])
    );
  }
}
