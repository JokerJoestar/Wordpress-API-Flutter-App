import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/articlesmodel.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/articlecard.dart';
import 'package:wp_flutter_app/widgets/customscaffold.dart';
import 'package:wp_flutter_app/widgets/nopagetransition.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _scrollController = ScrollController();
  ArticlesModel articles;
  List<Category> categories;
  String searchText;

  void getCategories() async {
    categories = new List<Category>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var categoriesString = prefs.getString('categories');

    categories.addAll(
        json.decode(categoriesString).map<Category>((m) => Category.fromJson(m)).toList());
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        articles.loadMore();
      }
    });

    getCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
          Padding(
              padding:
                  EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
              child: TextField(
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.title.merge(TextStyle(color: Color.fromRGBO(58, 58, 58, 1), fontSize: 21)),
                  onSubmitted: (text) {
                    setState(() {
                      if (text != searchText && text.isNotEmpty) {
                        searchText = text;
                        articles = new ArticlesModel(
                            "${con.WordpressUrl}/wp-json/wp/v2/posts", null, text);
                      }
                    });
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      prefixIcon: Icon(Icons.search, size: 30),
                      hintText: "Αναζήτηση...",
                      hintStyle: TextStyle(fontSize: 21),
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 28.0),
                          borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[350], width: 28.0),
                          borderRadius: BorderRadius.circular(15.0))))),
           Expanded(child: Padding(
                  padding: EdgeInsets.only(right: 8, left: 8),
                  child: futureWidget()))
        ]));
  }

  Widget futureWidget() {
    if(articles != null) {
    return StreamBuilder<List<Article>>(
      stream: articles.stream,
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
         return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            }, child: OrientationBuilder(builder: (context, orientation) {
                      return StaggeredGridView.countBuilder(
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
                                  categories, _snapshot.data, index);
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
                          }); 
            }));
        } else if (_snapshot.hasError) {
          return new Text("${_snapshot.error}");
        }
        return new Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  else return Container();
  }
}
