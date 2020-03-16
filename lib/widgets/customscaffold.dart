import 'package:flutter/material.dart';
import 'package:wp_flutter_app/models/pageroute.dart' as pageRoute;
import 'package:wp_flutter_app/pages/search.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/pages/categories.dart';
import 'package:wp_flutter_app/pages/home.dart';

class CustomScaffold extends StatefulWidget {
  final Widget bodyWidget;
  final int pageIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomScaffold(
      {Key key, this.bodyWidget, this.scaffoldKey, this.pageIndex})
      : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  GlobalKey _bottomNavigationKey = GlobalKey();

  List pages = [
    pageRoute.PageRoute(
      iconData: Icons.home,
      page: Home(),
    ),
    pageRoute.PageRoute(
        iconData: Icons.assignment,
        page: Categories(),
      ),
    pageRoute.PageRoute(
        iconData: Icons.search,
        page: Center(
          child: Search(),
        ))
  ];

  int _pageIndex = 0;
  Widget _bodyWidget;

  @override
  void initState() {
    super.initState();

    if(widget.pageIndex != null) {
      setState(() {
        _pageIndex = widget.pageIndex;
        _bodyWidget = widget.bodyWidget;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: con.PageBackgroundColor,
        appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: con.AppBarBackgroundColor,
            leading: new Container(width: 0, height: 0),
            centerTitle: true,
            title: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft)))),
        body: getWidget(),
        bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 22,
          selectedIconTheme:
              IconThemeData(size: 27, color: con.AppBarBackgroundColor),
          currentIndex: _pageIndex,
          elevation: 15,
          type: BottomNavigationBarType.fixed,
          items: pages
              .map((p) => BottomNavigationBarItem(
                  title: Text(''),
                  icon: Icon(
                    p.iconData,
                  )))
              .toList(),
          onTap: (index) {
            setState(() { _pageIndex = index; _bodyWidget = null; } );
          },
        ),
    );
  }

  getWidget() {
    if(_bodyWidget != null && _pageIndex == 1)
      return SafeArea(child: _bodyWidget);
    else
      return SafeArea(child: pages[_pageIndex].page);
  }
}
