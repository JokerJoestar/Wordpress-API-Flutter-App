import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wp_flutter_app/models/article.dart';

class ArticleView extends StatefulWidget {
  final Article article;

  const ArticleView({Key key, this.article}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.article.title),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: HtmlWidget(
                    widget.article.content,
                    webView: false,
                  )),
        ])));
  }
}
