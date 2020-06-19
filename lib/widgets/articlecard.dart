import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/pages/articleview.dart';
import 'nopagetransition.dart';
import 'dart:convert';

class ArticleCard extends StatefulWidget {
  final List<Category> categories;
  final List<Article> favorites;
  final List<Article> articles;
  final int index;
  final VoidCallback onDelete;
  ArticleCard(this.categories, this.favorites, this.articles, this.index,
      {this.onDelete});

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool isFavorite;
  List<Article> favorites;

  @override
  void initState() {
    super.initState();

    favorites = widget.favorites;
    // init favorite value
    checkIfArticleIsOnFavorites(widget.articles[widget.index], favorites);
  }

  Widget build(BuildContext context) {
    Article article = widget.articles[widget.index];

    return Card(
        shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(8.0),
            ),
        elevation: 4.0,
        margin: EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(NoPageTransition(
                  page: ArticleView(
                      articles: widget.articles, index: widget.index)));
            },
            child: getCardView(article, context)));
  }

  getCardView(Article article, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(children: [
          ClipRRect(
              child: Container(
            height: 160,
            width: double.maxFinite,
            child: CachedNetworkImage(
              alignment: Alignment.center,
              imageUrl: article.postImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
                height: 40.0,
                width: 40.0,
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )),
          Container(
            height: 160,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          ),
          showCategory(article, context)
        ]),
        showTitle(article, context)
      ],
    );
  }

  Widget showTitle(Article article, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.categories == null ? article.description : article.title,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(padding: const EdgeInsets.all(1)),
          Row(children: [
            Text(
              article.publishedDate,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          setArticleOnFavorites(article);
                          setState(() {});
                        },
                        child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.favorite,
                                color: isFavorite
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                        .withAlpha(150),
                                size: 26))))),
            Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Share.share(article.link);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(Icons.share,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withAlpha(150),
                            size: 26))))
          ])
        ],
      ),
    );
  }

  Widget showCategory(Article article, BuildContext context) {
    if (widget.categories != null) {
      return Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: con.AppBarBackgroundColor,
              border: new Border(
                top: BorderSide(color: con.AppBarBackgroundColor, width: 2),
                bottom: BorderSide(color: con.AppBarBackgroundColor, width: 2),
                left: BorderSide(color: con.AppBarBackgroundColor, width: 5),
                right: BorderSide(color: con.AppBarBackgroundColor, width: 5),
              ),
            ),
            child: Text(getCategoryNameFromId(article.categories[0]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline2),
          ));
    } else {
      return Container(
          padding: const EdgeInsets.only(
              top: 8.0, left: 8.0, right: 8.0, bottom: 4.0),
          height: 160,
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              )));
    }
  }

  getCategoryNameFromId(int categoryId) {
    String category = "";

    for (int i = 0; i < widget.categories.length; i++)
      if (widget.categories[i].id == categoryId) {
        category = widget.categories[i].name;
        break;
      }

    return category;
  }

// if is already on favorites icon doenst change color
  setArticleOnFavorites(Article article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isFavorite == false) {
      favorites.add(article);
      isFavorite = true;
      await prefs.setString('favorites', jsonEncode(favorites));
    } else {
      if (widget.onDelete != null)
        widget.onDelete();
      else {
        favorites.removeWhere((item) => item.id == article.id);
        isFavorite = false;
        await prefs.setString('favorites', jsonEncode(favorites));
      }
    }
  }

  checkIfArticleIsOnFavorites(Article article, List<Article> articles) {
    bool alreadyIn = false;

    if (articles.length > 0) {
      for (int i = 0; i < articles.length; i++) {
        if (articles[i].id == article.id) {
          alreadyIn = true;
          break;
        }
      }
    }

    isFavorite = alreadyIn;

    return alreadyIn;
  }
}
