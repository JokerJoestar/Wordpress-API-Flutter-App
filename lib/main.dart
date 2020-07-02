import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'variables/constants.dart' as con;
import 'package:http/http.dart' as http;
import 'package:wp_flutter_app/helpers/dataInitialization.dart';
import 'widgets/customscaffold.dart';
import 'models/article.dart';
import 'widgets/nopagetransition.dart';
import 'pages/articleview.dart';
import 'package:admob_flutter/admob_flutter.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  Admob.initialize();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('el', 'GR')],
      path: 'assets/languages',
      fallbackLocale: Locale('el', 'GR'), child: MyApp()));
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

    final hsl = HSLColor.fromColor(con.AppBarBackgroundColor);

    FlutterStatusbarcolor.setStatusBarColor(hsl.withLightness((hsl.lightness - 0.06).clamp(0.0, 1.0)).toColor());

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Wordpress Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: colorCustom,
          accentColor: colorCustom,
          textTheme: TextTheme(
            overline: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 28,
                color: con.AppBarBackgroundColor,
                letterSpacing: 0.15,
                shadows: [
                  Shadow(
                      // bottomRight
                      offset: Offset(1.2, 1.2),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 1.3),
                ]),
            headline5: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            headline2: TextStyle(
                fontFamily: 'Direct-Bold',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            bodyText1: TextStyle(
                fontFamily: 'Direct-Regular',
                fontSize: 14,
                color: Color.fromRGBO(128, 128, 128, 1)),
            subtitle2: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 28,
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
                      color: con.AppBarBackgroundColor.withOpacity(0.8),
                      blurRadius: 1.4),
                  Shadow(
                      // topLeft
                      offset: Offset(-0.8, 0.8),
                      color: con.AppBarBackgroundColor.withOpacity(0.8),
                      blurRadius: 1.4),
                ]),
            headline6: TextStyle(
                fontFamily: 'PFDInSerif-Bold',
                fontSize: 22,
                color: Colors.black,
                letterSpacing: 0.2),
            bodyText2: TextStyle(
                fontFamily: 'Direct-Regular',
                fontSize: 18,
                color: Colors.black,
                letterSpacing: -0.4,
                wordSpacing: -0.8),
            headline4: TextStyle(
              fontSize: 20,
              fontFamily: 'Direct-Bold',
              color: Color.fromRGBO(8, 8, 8, 1),
            ),
            headline3: TextStyle(
                fontSize: 28,
                fontFamily: 'Direct-Bold',
                color: Colors.grey[50],
                shadows: [
                  Shadow(
                      color: Colors.black87,
                      blurRadius: 1.6,
                      offset: Offset.fromDirection(1, 2))
                ]),
            subtitle1: TextStyle(
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences sharedPreferences;
  bool _loaded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    initPlatformState();
    Admob.initialize(testDeviceIds: ["EE12B2D340E1ADC675D4D752691F0266"]);
    DataInitialization.loadCategories().whenComplete(() => setState(() => _loaded = true));
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      sharedPreferences = prefs;

      // initialize OS subscription the first time the app loads
      if(prefs.getString("notifications") == null) {
        OneSignal.shared.setSubscription(true);
        prefs.setString("notifications", "");
      }
    });
    
    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      setState(() => notification.payload.launchUrl = null);
    });

    OneSignal.shared.setNotificationOpenedHandler((result) {
      OSNotificationPayload payload = result.notification.payload;
      Map<String, dynamic> additionalData = payload.additionalData;

      setState(() =>
          openWebview(payload.body, additionalData["article"].toString()));
    });

    await OneSignal.shared
        .init("8776c29b-18e7-43b8-a847-02d6dfeacd66", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return Container();

    return CustomScaffold(scaffoldKey: _scaffoldKey);
  }

  void openWebview(String title, String url) async {
    List<Article> articles = new List<Article>();
    int jsonWays;

    if (url.contains(con.WordpressUrl)) {
      String urlEndpoint = "${con.WordpressUrl}/wp-json/wp/v2/posts";

      if (url.contains("/?p=")) {
        urlEndpoint += "/${url.substring(url.lastIndexOf("/?p=") + 4)}?_embed";
        jsonWays = 0;
      } else {
        var urls = url.split("/");
        urlEndpoint += "?slug=${urls[urls.length - 2]}&_embed";
        jsonWays = 1;
      }

      var response = await http.get(urlEndpoint);

      if (response.statusCode == 200) {
        switch(jsonWays) {
          case 0: {
            articles.add(Article.fromJson(json.decode(response.body)));
            break;
          }
          case 1: {
            articles.addAll(json.decode(response.body).map<Article>((m) => Article.fromJson(m)).toList());
            break;
          }
          default: break;
        }

        Navigator.push(context, NoPageTransition(
            page: ArticleView(articles: articles, index: 0, pageIndex: 0)));
      }
    }
  }
}
