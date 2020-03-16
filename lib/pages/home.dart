import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/articlesmodel.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/articlecard.dart';
import 'package:wp_flutter_app/widgets/customscaffold.dart';
import 'package:wp_flutter_app/widgets/filestorage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();
  ArticlesModel articles;
  FileStorage storage = new FileStorage();
  List<Category> categories;

  void getCategories() async {
    categories = new List<Category>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var categoriesString = prefs.getString('categories');

    categories.addAll(
        json.decode(categoriesString).map<Category>((m) => Category.fromJson(m)).toList());
  }

  @override
  void initState() {
    articles = ArticlesModel("${con.WordpressUrl}/wp-json/wp/v2/posts", null);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        articles.loadMore();
      }
    });

    getCategories();
    /*storage.readJsonCategories().then((c) => categories.addAll(
        json.decode(c).map<Category>((m) => Category.fromJson(m)).toList()));*/

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
                            /*if(MediaQuery.of(context).orientation == Orientation.portrait)
                                return new StaggeredTile.fit(1);
                              else 
                                return new StaggeredTile.count(1, 0.814025);*/
                            /*return new StaggeredTile.count(
                                  1,
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 0.777
                                      : 0.814025);*/
                          },
                          padding: const EdgeInsets.only(top: 16.0),
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (index < _snapshot.data.length) {
                              return ArticleCard(
                                  categories, _snapshot.data[index]);
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
