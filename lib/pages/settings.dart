import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:wp_flutter_app/widgets/customscaffold.dart';
import 'aboutus.dart';
import 'package:wp_flutter_app/widgets/nopagetransition.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _loaded = false;
  bool _isUserSubscribed;

  @override
  void initState() {
    isUserOSSubscribed()
        .then((value) => _isUserSubscribed = value)
        .whenComplete(() => setState(() => _loaded = true));

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: settingsWidget());
  }

  Future<bool> isUserOSSubscribed() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    return status.subscriptionStatus.subscribed;
  }

  // https://www.thirdrocktechkno.com/blog/how-to-implement-localization-in-flutter
  // I can use that and shared preferences to create multiple languages on application

  Widget settingsWidget() {
    if (!_loaded) return Container();

    return Column(children: [
      Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  MergeSemantics(
                    child: ListTile(
                      leading: _isUserSubscribed
                          ? Icon(Icons.notifications, color: Colors.black)
                          : Icon(Icons.notifications_off, color: Colors.black),
                      title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text('Ειδοποιήσεις',
                              style: Theme.of(context).textTheme.headline4)),
                      trailing: CupertinoSwitch(
                        activeColor: con.AppBarBackgroundColor,
                        value: _isUserSubscribed,
                        onChanged: (bool value) {
                          setState(() {
                            _isUserSubscribed = value;
                            changeSubscription(_isUserSubscribed);
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _isUserSubscribed = !_isUserSubscribed;
                          changeSubscription(_isUserSubscribed);
                        });
                      },
                    ),
                  ),
                  Container(height: 1, color: Colors.grey[350]),
                  MergeSemantics(
                    child: ListTile(
                      leading: Icon(Icons.opacity, color: Colors.black),
                      title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text('Στοιχεία Επικοινωνίας',
                              style: Theme.of(context).textTheme.headline4)),
                      onTap: () {
                        Navigator.of(context).push(NoPageTransition(
                            page: CustomScaffold(
                                showBackButton: true,
                                pageIndex: 4,
                                bodyWidget: AboutUs())));
                      },
                    ),
                  ),
                  Container(height: 1, color: Colors.grey[350]),
                  MergeSemantics(
                    child: ListTile(
                      leading: Icon(Icons.feedback, color: Colors.black),
                      title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text('Ανατροφοδότηση εφαρμογής',
                              style: Theme.of(context).textTheme.headline4)),
                      onTap: () {
                        setState(() {
                          launch('mailto:asdasdas@asdasdasd.gr?subject=Ανατροφοδότηση εφαρμογής&body=');
                        });
                      },
                    ),
                  ),
                  Container(height: 1, color: Colors.grey[350]),
                ],
              )))
    ]);
  }

  void changeSubscription(bool sub) {
    OneSignal.shared.setSubscription(sub);

    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
          context: context,
          child: new AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
            content: new Text(
                sub
                    ? "Μόλις ενεργοποιήσατε την λήψη ειδοποιήσεων."
                    : "Μόλις απενεργοποιήσατε την λήψη ειδοποιήσεων.",
                style: Theme.of(context).textTheme.headline4),
            actions: [
              FlatButton(
                color: Colors.grey[200],
                child: Text('Ok', style: Theme.of(context).textTheme.headline6),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    });
  }
}
