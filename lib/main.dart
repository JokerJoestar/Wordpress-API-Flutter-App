import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_flutter_app/models/category.dart';
import 'variables/constants.dart' as con;
import 'package:http/http.dart' as http;
import 'widgets/customscaffold.dart';
import 'widgets/filestorage.dart';

main() {
  runApp(MyApp());
}

Map<int, Color> color = {
  50: con.AppBarBackgroundColor.withOpacity(0.1),
  100: con.AppBarBackgroundColor.withOpacity(0.2),
  200: con.AppBarBackgroundColor.withOpacity(0.3),
  300: con.AppBarBackgroundColor.withOpacity(0.4),
  400: con.AppBarBackgroundColor.withOpacity(0.5),
  500: con.AppBarBackgroundColor.withOpacity(0.6),
  600: con.AppBarBackgroundColor.withOpacity(0.7),
  700: con.AppBarBackgroundColor.withOpacity(0.8),
  800: con.AppBarBackgroundColor.withOpacity(0.9),
  900: con.AppBarBackgroundColor.withOpacity(1),
};

MaterialColor colorCustom = MaterialColor(0xFF1A1A1A, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: colorCustom,
          accentColor: colorCustom,
          textTheme: TextTheme(
            overline: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 28,
                color: Color(0xFF0e4d92),
                letterSpacing: 0.15,
                shadows: [
                  Shadow(
                      // bottomRight
                      offset: Offset(1.2, 1.2),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.3),
                ]),
            headline: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            display3: TextStyle(
                fontFamily: 'Direct-Bold',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            body2: TextStyle(
                fontFamily: 'Direct-Regular',
                fontSize: 14,
                color: Color.fromRGBO(128, 128, 128, 1)),
            subtitle: TextStyle(
                fontFamily: 'PFDInSerif-Regular',
                fontSize: 23,
                color: Colors.white,
                letterSpacing: 0.02,
                shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-0.8, -0.8),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.4),
                  Shadow(
                      // bottomRight
                      offset: Offset(0.8, -0.8),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.4),
                  Shadow(
                      // topRight
                      offset: Offset(0.8, 0.8),
                      color: Color(0xFF0e4d92).withOpacity(0.8),
                      blurRadius: 1.4),
                  Shadow(
                      // topLeft
                      offset: Offset(-0.8, 0.8),
                      color: Color(0xFF0e4d92).withOpacity(0.8),
                      blurRadius: 1.4),
                ]),
            title: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 22,
                color: Colors.black,
                letterSpacing: 0.2),
            body1: TextStyle(
                fontFamily: 'Direct-Regular',
                fontSize: 18,
                color: Colors.black,
                letterSpacing: -0.4,
                wordSpacing: -0.8),
            display1: TextStyle(
              fontSize: 20,
              fontFamily: 'Direct-Bold',
              color: Color.fromRGBO(8, 8, 8, 1),
            ),
            display2: TextStyle(
                fontSize: 28,
                fontFamily: 'Direct-Bold',
                color: Colors.grey[50],
                shadows: [
                  Shadow(
                      color: Colors.black87,
                      blurRadius: 1.6,
                      offset: Offset.fromDirection(1, 2))
                ]),
            subhead: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 21,
                color: Colors.white,
                letterSpacing: 0.3,
                shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-1, -1),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.6),
                  Shadow(
                      // bottomRight
                      offset: Offset(1, -1),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.6),
                  Shadow(
                      // topRight
                      offset: Offset(1, 1),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.6),
                  Shadow(
                      // topLeft
                      offset: Offset(-1, 1),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.6),
                ]),
          )),
      home: MyHomePage(title: 'Flutter Demo Home Page', storage: FileStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FileStorage storage;
  MyHomePage({Key key, this.title, this.storage}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences sharedPreferences;
  bool _loaded = false;

  Future<void> loadCategories() async {
    await SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      sharedPreferences = prefs;
      var page = 1;
      bool hasMore = true;
      var tempCategories = new List<Category>();

      do {
        var url =
            con.WordpressUrl + "wp-json/wp/v2/categories?page=$page&per_page=40";

        var response =
            await http.get(url, headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          tempCategories.addAll(json
              .decode(response.body)
              .map<Category>((m) => Category.fromJson(m))
              .toList());

          if (tempCategories.length % 40 != 0) {
            hasMore = false;
            break;
          }
        }

        page++;
      } while (hasMore);

      //await widget.storage.writeJsonCategories(jsonEncode(tempCategories));
      await sharedPreferences.setString('categories', jsonEncode(tempCategories));
    });
  }

  @override
  void initState() {
    super.initState();

    loadCategories().whenComplete(() => setState(() => _loaded = true));
  }

  @override
  Widget build(BuildContext context) {
    if(!_loaded)
      return Container();

    return CustomScaffold();
  }
}
