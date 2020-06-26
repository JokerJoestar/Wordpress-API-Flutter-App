import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wp_flutter_app/models/pageroute.dart' as pageRoute;
import 'package:wp_flutter_app/pages/favorites.dart';
import 'package:wp_flutter_app/pages/search.dart';
import 'package:wp_flutter_app/pages/settings.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/pages/categories.dart';
import 'package:wp_flutter_app/pages/home.dart';

class CustomScaffold extends StatefulWidget {
  final Widget bodyWidget;
  final int pageIndex;
  final Widget appBar;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomScaffold(
      {Key key, this.bodyWidget, this.scaffoldKey, this.pageIndex, this.appBar})
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
      iconData: Icons.favorite,
      page: Favorites(),
    ),
    pageRoute.PageRoute(
        iconData: Icons.assignment,
        page: Categories(),
      ),
    pageRoute.PageRoute(
        iconData: Icons.search,
        page: Search()
      ),
    pageRoute.PageRoute(
        iconData: Icons.settings,
        page: Settings()
      )
  ];

  int _pageIndex = 0;
  Widget _bodyWidget;
  Widget _appBar;

  @override
  void initState() {
    super.initState();

    if(widget.pageIndex != null) {
      setState(() {
        _pageIndex = widget.pageIndex;
        _bodyWidget = widget.bodyWidget;
        _appBar = widget.appBar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      key: widget.scaffoldKey,
      backgroundColor: con.PageBackgroundColor,
        appBar: _appBar == null ? AppBar(
            brightness: Brightness.dark,
            backgroundColor: con.AppBarBackgroundColor,
            leading: new Container(width: 0, height: 0),
            centerTitle: true,
            title: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: GestureDetector(onTap: () {
                      if(canLaunch(con.WordpressUrl) != null)
                        launch(con.WordpressUrl);
                    }, child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft))))) : _appBar,
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
            setState(() { 
              _pageIndex = index; 
              _appBar = null; 
              _bodyWidget = null; 
            } );
          },
        ),
    );
  }

  getWidget() {
    if(_bodyWidget != null)
      return SafeArea(child: _bodyWidget);
    else
      return SafeArea(child: pages[_pageIndex].page);
  }
}
