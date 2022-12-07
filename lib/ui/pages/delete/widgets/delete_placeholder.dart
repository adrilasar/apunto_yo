import 'package:flutter/material.dart';

import '../../../widgets/place_holder.dart';

class DeletePlaceHolder extends StatelessWidget {
  const DeletePlaceHolder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(title: Text('Papelera')),
            pinned: true,
            expandedHeight: 120.0),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 200,
                  child: PlaceHolder(),
                ),
              );
            },
            childCount: 3,
          ),
        ),
      ],
    );
  }
}
