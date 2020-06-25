import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/helpers/ads.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/widgets/articlecard.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Category> categories;
  List<Article> favorites;
  bool _loaded = false;

  void getCategories() async {
    categories = new List<Category>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var categoriesString = prefs.getString('categories');

    categories.addAll(json
        .decode(categoriesString)
        .map<Category>((m) => Category.fromJson(m))
        .toList());
  }

  Future<void> getFavorites() async {
    favorites = new List<Article>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var favoritesString = prefs.getString('favorites');

    if (favoritesString != null) {
      favorites.addAll(json
          .decode(favoritesString)
          .map<Article>((m) => Article.simpleFromJson(m))
          .toList());
    }
  }

  @override
  void initState() {
    Ads.hideBannerAd();
    getCategories();
    getFavorites().whenComplete(() => setState(() => _loaded = true));
    super.initState();
  }

  void removeItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (index == null)
        favorites = new List<Article>();
      else
        favorites = List.from(favorites)..removeAt(index);

      prefs.setString('favorites', jsonEncode(favorites));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded == true)
      return Scaffold(body: futureWidget());
    else
      return Container();
  }

  Widget futureWidget() {
    if (favorites == null || favorites.length == 0) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Text('Δεν βρέθηκαν \nαποθηκευμένα άρθρα.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'PFDInSerif-Bold', fontSize: 23))),
      );
    } else {
      return Column(children: [
        Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        }, child: OrientationBuilder(builder: (context, orientation) {
          return Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 1
                          : 2,
                  itemCount: favorites.length + 1,
                  staggeredTileBuilder: (int index) {
                    if (index == 0)
                      return new StaggeredTile.fit(2);
                    else
                      return new StaggeredTile.fit(1);
                  },
                  padding: const EdgeInsets.only(top: 5),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                          padding:
                              EdgeInsets.only(left: 50, right: 50, bottom: 5),
                          child: RaisedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    child: new AlertDialog(
                                      contentPadding: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      content: new Text(
                                          "Θέλετε να διαγράψατε όλα τα αποθηκευμένα άρθρα;",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      actions: [
                                        FlatButton(
                                          color: Colors.grey[200],
                                          child: Text('Ναι',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() => removeItem(null));
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.grey[200],
                                          child: Text('Όχι',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ));
                              },
                              child: Text('Διαγραφή όλων',
                                  style:
                                      Theme.of(context).textTheme.headline4)));
                    } else {
                      final item = favorites[--index];

                      return Dismissible(
                        child: ArticleCard(
                            categories, favorites, favorites, index,
                            pageIndex: 1, showAd: false, onDelete: () {
                          setState(() => removeItem(index));
                        }),
                        onDismissed: (direction) {
                          setState(() => removeItem(index));
                        },
                        key: Key(item.link),
                      );
                    }
                  }));
        }))),
      ]);
    }
  }
}
