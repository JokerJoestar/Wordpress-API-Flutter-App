import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/helpers/ads.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/articlesmodel.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/articlecard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();
  ArticlesModel articles;
  List<Category> categories;
  List<Article> favorites;

  void getCategories() async {
    categories = new List<Category>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var categoriesString = prefs.getString('categories');

    categories.addAll(
        json.decode(categoriesString).map<Category>((m) => Category.fromJson(m)).toList());
  }

  void getFavorites() async {
    favorites = new List<Article>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var favoritesString = prefs.getString('favorites');

    if(favoritesString != null) {
      favorites.addAll(json.decode(favoritesString).map<Article>((m) => Article.simpleFromJson(m)).toList());
    }
  }

  @override
  void initState() {
    Ads.hideBannerAd();
    articles = ArticlesModel("${con.WordpressUrl}/wp-json/wp/v2/posts", null, null);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        articles.loadMore();
      }
    });

    getCategories();
    getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(body: futureWidget());
  }

  Widget futureWidget() {
    return StreamBuilder<List<Article>>(
      stream: articles.stream,
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          return RefreshIndicator(
              backgroundColor: con.RefreshBackgroundColor,
              color: con.RefreshColor,
              onRefresh: articles.refresh,
              child: Column(children: [
                Expanded(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                            onNotification:
                                (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return;
                }, child: OrientationBuilder(builder: (context, orientation) {
                  return Container(
                      margin: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: StaggeredGridView.countBuilder(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 1
                              : 2,
                          itemCount: _snapshot.data.length + 1,
                          staggeredTileBuilder: (int index) {
                            if (index == _snapshot.data.length)
                              return new StaggeredTile.fit(2);
                            else
                              return new StaggeredTile.fit(1);
                          },
                          padding: const EdgeInsets.only(top: 16.0),
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (index < _snapshot.data.length) {
                              return ArticleCard(
                                  categories, favorites, _snapshot.data, index);
                            } else if (articles.hasMore) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: Center(
                                    child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 3))),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: Center(
                                    child: Text('Δεν βρέθηκαν άλλα άρθρα.',
                                        style: TextStyle(
                                            fontFamily: 'PFDInSerif-Bold',
                                            fontSize: 18))),
                              );
                            }
                          }));
                }))),
              ]));
        } else if (_snapshot.hasError) {
          return new Text("${_snapshot.error}");
        }
        return new Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
