import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/pages/articleview.dart';
import 'nopagetransition.dart';

class ArticleCard extends StatelessWidget {
  final List<Category> categories;
  final List<Article> articles;
  final int index;
  ArticleCard(this.categories, this.articles, this.index);

  Widget build(BuildContext context) {
    Article article = articles[index];

    return Card(
        shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(8.0),
            ),
        elevation: 4.0,
        margin: EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
        child: InkWell(onTap: () { Navigator.of(context).push(NoPageTransition(
                  page: ArticleView(articles: articles, index: index))); }, child: getCardView(article, context)));
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

  getCardView(Article article, BuildContext context) {    
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(children: [
          ClipRRect(
              //borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0) ),
              child: Container(
            height: 160,
            width: double.maxFinite,
            child: CachedNetworkImage(
              alignment: Alignment.center,
              imageUrl: article.postImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: SizedBox(
                child: CircularProgressIndicator(strokeWidth: 3,),
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
    if(categories != null) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                article.title,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.title,
              ),
              Padding(padding: const EdgeInsets.all(1)),
              Text(
                article.publishedDate,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body2,
              ),
            ],
          ),
        );
    } else {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              article.description.isNotEmpty ? Text(
                article.description,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1,
              ) : Container(),
              Padding(padding: const EdgeInsets.all(1)),
              Align(alignment: Alignment.bottomRight, child: Text(
                article.publishedDate,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body2,
              )),
            ],
          ),
        );
    }
  }
  Widget showCategory(Article article, BuildContext context) {
    if(categories != null) {
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
                child: Text(getCategoryNameFromId(article.categories[0]), maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.display3),
              ));
    } else {
      return Container(padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 4.0), height: 160, child: Align(alignment: Alignment.bottomLeft, child: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subhead,
                    )
                  )
                );
    }
  }

  getCategoryNameFromId(int categoryId) {
    String category = "";

    for(int i=0; i < categories.length; i++)
      if(categories[i].id == categoryId) {
        category = categories[i].name;
        break;
    }

    return category;
  }
}
