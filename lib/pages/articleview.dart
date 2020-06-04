import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share/share.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/customscaffold.dart';

class ArticleView extends StatefulWidget {
  final List<Article> articles;
  final int index;

  const ArticleView({Key key, this.articles, this.index}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  Article article;
  int index;
  PageController pageController;
  final GlobalKey<_ArticleAppBarState> _articleAppBarState = GlobalKey<_ArticleAppBarState>();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    pageController = PageController(initialPage: index);

    setState(() {
      article = widget.articles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageIndex: 0,
      appBar: ArticleAppBar(article: article, key: _articleAppBarState),
      // title doesnt change
      /*appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: con.AppBarBackgroundColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(article.link);
                }),
          ],
          title: Text(article.title)),*/
      bodyWidget: PageView.builder(
        itemBuilder: (context, int currentIdx) {
          return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, int index) {
                    return Column(children: [
                      /*CachedNetworkImage(
                    alignment: Alignment.center,
                    imageUrl: widget.articles[currentIdx].postImage,
                    fit: BoxFit.cover),*/
                      Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            widget.articles[currentIdx].title,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.overline,
                          )),
                      HtmlWidget(widget.articles[currentIdx].content,
                          webView: false)
                    ]);
                  }));
        },
        itemCount: widget.articles.length,
        controller: pageController,
        onPageChanged: (pageId) {
          setState(() {
            article = widget.articles[pageId];
            _articleAppBarState.currentState.reRender(article);
          });
        },
      ),
    );
  }
}

class ArticleAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Article article;

  ArticleAppBar({Key key, this.article}):super(key:key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _ArticleAppBarState createState() => _ArticleAppBarState();
}

class _ArticleAppBarState extends State<ArticleAppBar> {
  Article _article;

  @override
  void initState() {
    super.initState();

    _article = widget.article;
  }

  reRender(Article article) {
    setState(() {
      _article = article;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
          brightness: Brightness.dark,
          backgroundColor: con.AppBarBackgroundColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(_article.link);
                }),
          ],
          title: Text(_article.title));
  }
}
