import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wp_flutter_app/models/article.dart';
import 'package:wp_flutter_app/widgets/nopagetransition.dart';

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
  int _lowerCount = 0;
  int _upperCount = 0;
  String _title = "";

  List<Widget> _pages = new List<Widget>();

  @override
  void initState() {
    super.initState();
    index = widget.index;

    setState(() { 
      article = widget.articles[index]; 
      _title = article.title;

      if(index > 0) {
        _lowerCount = -1;
        _pages.add(HtmlWidget(
                      widget.articles[index-1].content,
                      webView: false,
                    ));
      }

      _pages.add(HtmlWidget(
                    article.content,
                    webView: false,
                  ));

      if(index < widget.articles.length-1)
      _upperCount = 1;
      _pages.add(HtmlWidget(
                    widget.articles[index+1].content,
                    webView: false,
                  ));
    });
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(_title)), 
    body: PageView(
          onPageChanged: (pageId) {
            if (pageId == _pages.length - 1 && index < widget.articles.length - 1) {
              print("Last page, add page to end");

              index++;
              article = widget.articles[index]; 

              _upperCount = _upperCount + 1;
              _pages.add(new HtmlWidget(
                    article.content,
                    webView: false,
                  ));
                  
              setState(() { article = widget.articles[index]; _title = article.title; });
            }
            if (pageId == -1 && index > 0) {
              print('p');
              _lowerCount = _lowerCount - 1;

              index--;
              article = widget.articles[index]; 

              Widget w = new HtmlWidget(
                    article.content,
                    webView: false,
                  );
              _pages = [w]..addAll(_pages);

              setState(() { article = widget.articles[index]; _title = article.title; });
            }

            _title = article.title;
          },
          controller: PageController(
            initialPage: index==0 ? 0 : 1,
          ),
          children: _pages,
        ),);
    /*return Scaffold(
        appBar: AppBar(
          title: Text(article.title),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: GestureDetector(onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            if(index < widget.articles.length-1) {
              print('asas');
              setState(() {
                  index++;
                  article = widget.articles[index]; 
              });
            }
          } else if (details.delta.dx < 0) {
            if(index > 0 && index < widget.articles.length-1) {
              print('adad');
              setState(() {
                  index--;
                  article = widget.articles[index]; 
              });
            }
          }
        }, child: HtmlWidget(
                    article.content,
                    webView: false,
                  ))),
        ])));*/
  }
}
