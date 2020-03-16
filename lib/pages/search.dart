import 'package:flutter/material.dart';

int _lowerCount = -1;
int _upperCount = 1;

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Widget> _pages = <Widget>[
    new Center(child: new Text("-1", style: new TextStyle(fontSize: 60.0))),
    new Center(child: new Text("0", style: new TextStyle(fontSize: 60.0))),
    new Center(child: new Text("1", style: new TextStyle(fontSize: 60.0)))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 50.0,
        ),
        child: PageView(
          onPageChanged: (pageId) {
            if (pageId == _pages.length - 1) {
              print("Last page, add page to end");
              _upperCount = _upperCount + 1;
              _pages.add(new Center(child: new Text(_upperCount.toString(), style: new TextStyle(fontSize: 60.0))));
              setState(() {});
            }
            if (pageId == 0) {
              print("First page, add page to start");
              _lowerCount = _lowerCount - 1;
              Widget w = new Center(child: new Text(_lowerCount.toString(), style: new TextStyle(fontSize: 60.0)));
              _pages = [w]..addAll(_pages);
              setState(() {});
            }
          },
          controller: PageController(
            initialPage: 1,
          ),
          children: _pages,
        ),
      ),
    );
  }
}