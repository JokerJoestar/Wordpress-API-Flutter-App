import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share/share.dart';
import 'package:wp_flutter_app/helpers/ads.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/customscaffold.dart';

class ArticleView extends StatefulWidget {
  final int pageIndex;
  final List<Article> articles;
  final int index;
  final bool showAd;

  const ArticleView(
      {Key key, this.articles, this.index, this.pageIndex, this.showAd})
      : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  Article article;
  int index;
  PageController pageController;

  final GlobalKey<_ArticleAppBarState> _articleAppBarState =
      GlobalKey<_ArticleAppBarState>();

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
    if (widget.showAd == true)
      Ads.showBannerAd();

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          if (widget.showAd == true) 
            Ads.hideBannerAd();

          return false;
        },
        child: CustomScaffold(
          pageIndex: widget.pageIndex,
          appBar: ArticleAppBar(article: article, key: _articleAppBarState),
          bodyWidget: PageView.builder(
            itemBuilder: (context, int currentIdx) {
              return NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                          bottom: Ads.getBannerAd() != null
                              ? Ads.getBannerAd().size.height.toDouble()
                              : 0),
                      child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, int index) {
                            return Column(children: [
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
                          })));
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
        ));
  }
}

class ArticleAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Article article;

  ArticleAppBar({Key key, this.article}) : super(key: key);

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
