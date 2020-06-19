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
        /*child: InkWell(
            radius: 5.0,
            onTap: () {
              Navigator.of(context).push(NoPageTransition(
                  page: Scaffold(
                      appBar: AppBar(
                          actions: <Widget>[
                            IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(article.link);
                                }),
                          ],
                          brightness: Brightness.dark,
                          backgroundColor: Color.fromRGBO(8, 8, 8, 1),
                          centerTitle: true,
                          title: ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxHeight: 200, maxWidth: 200),
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Image.asset('assets/images/lplogo.png',
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.centerLeft)))),
                      body: WebView(
                        initialUrl: article.link,
                        javascriptMode: JavascriptMode.unrestricted,
                      ))));
              
            },*/
  }

  getCardView(BuildContext context) {
    var size = MediaQuery.of(context).size.width / 2 - 52;
    return ClipRRect(
      //borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0) ),
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
    var colorHue = (p.hue - 30) + rng.nextInt(60) + rng.nextDouble();

    return p.withHue(colorHue).toColor().withOpacity(0.7);
  }
}
