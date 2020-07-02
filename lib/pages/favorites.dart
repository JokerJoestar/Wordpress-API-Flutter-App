import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/helpers/dataInitialization.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/widgets/articlecard.dart';
import 'package:easy_localization/easy_localization.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Category> categories = new List<Category>();
  List<Article> favorites = new List<Article>();
  bool _loaded = false;

  @override
  void initState() {
    DataInitialization.getCategories(categories).then((value) => categories == value);
    DataInitialization.getFavorites(favorites).then((value) => favorites == value).whenComplete(() => setState(() => _loaded = true));
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
            child: Text("no_saved_articles".tr(),
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
                                          "confirm_delete_saved_articles".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      actions: [
                                        FlatButton(
                                          color: Colors.grey[200],
                                          child: Text("yes".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            removeItem(null);
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.grey[200],
                                          child: Text("no".tr(),
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
                              child: Text("delete_all_saved_articles".tr(),
                                  style:
                                      Theme.of(context).textTheme.headline4)));
                    } else {
                      final item = favorites[--index];

                      return Dismissible(
                        child: ArticleCard(
                            categories, favorites, favorites, index,
                            pageIndex: 1, onDelete: () {
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
