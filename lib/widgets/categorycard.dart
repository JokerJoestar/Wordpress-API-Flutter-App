import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/pages/categories.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;

import 'customscaffold.dart';
import 'nopagetransition.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(8.0),
            ),
        elevation: 4.0,
        margin: EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
        child: InkWell(
          radius: 5.0,
          onTap: () {
             Navigator.of(context).push(NoPageTransition(
                  page: CustomScaffold(pageIndex: 2, bodyWidget: Categories(category: category,))));
          },
          child: getCardView(context)));
  }

  getCardView(BuildContext context) {
    var size = MediaQuery.of(context).size.width / 2 - 52;
    return ClipRRect(
      child: Container(
          height: size,
          color: getRandomColor(),
          child: Center(
              child: Padding(padding: EdgeInsets.all(size/12), child: Text(category.name, style: Theme.of(context).textTheme.subtitle1, softWrap: true, textAlign: TextAlign.center,
                  maxLines: 2, overflow: TextOverflow.ellipsis)))),
    );
  }

  getRandomColor() {
    var p = HSLColor.fromColor(con.AppBarBackgroundColor);
    var rng = new Random();
    var colorHue = (p.hue - 30) + rng.nextInt(40) + rng.nextDouble();

    return p.withHue(colorHue).toColor().withOpacity(0.7);
  }
}
