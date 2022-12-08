import 'package:flutter/material.dart';

import '../../../widgets/place_holder.dart';

CustomScrollView buildDeletePlaceholder() {
  return CustomScrollView(
    slivers: <Widget>[
      const SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(title: Text('Papelera')),
          pinned: true,
          expandedHeight: 120.0),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: buildPlaceHolder(context),
              ),
            );
          },
          childCount: 3,
        ),
      ),
    ],
  );
}
