import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/pages/categoryarticles.dart';
import 'package:wp_flutter_app/widgets/categorycard.dart';

class Categories extends StatefulWidget {
  final Category category;

  const Categories({Key key, this.category}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Category> categories;
  
  @override
  void initState() {
    super.initState();
  }

  Future<List<Category>> findCategories() async {
    categories = new List<Category>();  
    SharedPreferences prefs = await SharedPreferences.getInstance();

    categories.addAll(
        json.decode(prefs.getString('categories')).map<Category>((m) => Category.fromJson(m)).toList());
    
    if(widget.category == null)
        return categories.where((c) => c.parent == 0).toList();
      else 
        return categories.where((c) => c.parent == widget.category.id).toList();
  }

  /*Future<List<Category>> findCategories() async {
    categories = new List<Category>();
    await storage.readJsonCategories().then((c) => categories.addAll(
        json.decode(c).map<Category>((m) => Category.fromJson(m)).toList()));

    if(widget.categoryId == null)
      return categories.where((c) => c.parent == 0).toList();
    else 
      return categories.where((c) => c.parent == widget.categoryId).toList();
  }*/

  Widget build(BuildContext context) {
    return Scaffold(body: futureWidget());
  }

  Widget futureWidget() {
    return FutureBuilder<List<Category>>(
      future: findCategories(),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          if((_snapshot.data as List).length == 0) {
            // show page with articles
            return CategoryArticles(category: widget.category);
          }
          else {
            return Column(children: [
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
                          crossAxisCount: 2,
                          itemCount: _snapshot.data.length,
                          staggeredTileBuilder: (int index) {
                            if (index == _snapshot.data.length)
                              return new StaggeredTile.fit(1);
                            else
                              return new StaggeredTile.fit(1);
                          },
                          padding: const EdgeInsets.only(top: 16.0),
                          //controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (index < _snapshot.data.length) {
                              return CategoryCard(_snapshot.data[index] as Category);
                            } else {
                              return Container();
                            }
                          }));
                }))),
              ]);
           }
        } else if (_snapshot.hasError) {
          return Text("${_snapshot.error}");
        }
        return Text('');
      },
    );
  }
}
