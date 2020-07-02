import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share/share.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/customscaffold.dart';

class ArticleView extends StatefulWidget {
  final int pageIndex;
  final List<Article> articles;
  final int index;

  const ArticleView({Key key, this.articles, this.index, this.pageIndex})
      : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  Article article;
  int index;
  PageController pageController;
  bool showAd;

  final GlobalKey<_ArticleAppBarState> _articleAppBarState =
      GlobalKey<_ArticleAppBarState>();

  @override
  void initState() {
    index = widget.index;
    pageController = PageController(initialPage: index);

    setState(() {
      article = widget.articles[index];
    });
    super.initState();
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS)
      return 'ca-app-pub-3940256099942544/2934735716';
    else if (Platform.isAndroid)
      return 'ca-app-pub-3940256099942544/6300978111';
    return null;

    // Didn't add payment info on account so these ads dont work...
    /*
    if (Platform.isIOS) {
      return 'ca-app-pub-1990887568219834/9440055022';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1990887568219834/7570492048';
    }
    return null; */
  }

  @override
  Widget build(BuildContext context) {
    showAd = true;

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: CustomScaffold(
            pageIndex: widget.pageIndex,
            appBar: ArticleAppBar(article: article, key: _articleAppBarState),
            bodyWidget: Column(children: [
              Expanded(
                  child: PageView.builder(
                itemBuilder: (context, int currentIdx) {
                  return NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return;
                    },
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
                                webView: false),
                          ]);
                        }),
                  );
                },
                itemCount: widget.articles.length,
                controller: pageController,
                onPageChanged: (pageId) {
                  setState(() {
                    article = widget.articles[pageId];
                    _articleAppBarState.currentState.reRender(article);
                  });
                },
              )),
              AdBanner(bannerId: getBannerAdUnitId())
            ])));
  }
}

class AdBanner extends StatefulWidget {
  final String bannerId;

  AdBanner({Key key, this.bannerId}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  var showAd = true;

  @override
  Widget build(BuildContext context) {
    return showAd == false
        ? Container()
        : AdmobBanner(
            adUnitId: widget.bannerId,
            adSize: AdmobBannerSize.BANNER,
            listener: (event, args) {
              if (event == AdmobAdEvent.failedToLoad) {
                showAd = false;
                setState(() {});
              }
            },
          );
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
