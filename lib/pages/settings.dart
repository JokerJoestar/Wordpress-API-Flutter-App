import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'aboutus.dart';
import 'package:wp_flutter_app/widgets/nopagetransition.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _loaded = false;
  bool _isUserSubscribed;
  Locale _selectedLocale;
  Widget dropDownMenu;

  @override
  void initState() {
    isUserOSSubscribed()
        .then((value) => _isUserSubscribed = value)
        .whenComplete(() => setState(() => _loaded = true));

    super.initState();
  }

  Widget build(BuildContext context) {
    if (_selectedLocale == null) _selectedLocale = context.locale;

    return Scaffold(body: settingsWidget(context));
  }

  Future<bool> isUserOSSubscribed() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    return status.subscriptionStatus.subscribed;
  }

  Widget settingsWidget(BuildContext context) {
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
                          child: Text("notifications".tr(),
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
                      leading: Icon(Icons.contacts, color: Colors.black),
                      title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text("contact_details".tr(),
                              style: Theme.of(context).textTheme.headline4)),
                      onTap: () {
                        Navigator.of(context).push(NoPageTransition(
                            page: AboutUs()));
                      },
                    ),
                  ),
                  Container(height: 1, color: Colors.grey[350]),
                  MergeSemantics(
                    child: ListTile(
                      leading: Icon(Icons.feedback, color: Colors.black),
                      title: Transform(
                          transform: Matrix4.translationValues(-16, 0.0, 0.0),
                          child: Text("app_feedback".tr(),
                              style: Theme.of(context).textTheme.headline4)),
                      onTap: () {
                        setState(() {
                          launch('mailto:asdasdas@asdasdasd.gr?subject=' +
                              "app_feedback".tr() +
                              '&body=');
                        });
                      },
                    ),
                  ),
                  Container(height: 1, color: Colors.grey[350]),
                  MergeSemantics(
                    child: ListTile(
                        leading: Icon(Icons.language, color: Colors.black),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text("change_language".tr(),
                                style: Theme.of(context).textTheme.headline4)),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<Locale>(
                            value: _selectedLocale,
                            onChanged: (value) {
                              _selectedLocale = value;

                              this.setState(() {
                                context.locale = _selectedLocale;
                              });
                            },
                            items: context.supportedLocales.map((Locale value) {
                              return new DropdownMenuItem<Locale>(
                                value: value,
                                child: new Text(value.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 20)),
                              );
                            }).toList(),
                          ),
                        )),
                  ),
                  Container(height: 1, color: Colors.grey[350])
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
                    ? "enable_notifications".tr()
                    : "disable_notifications".tr(),
                style: Theme.of(context).textTheme.headline4),
            actions: [
              FlatButton(
                color: Colors.grey[200],
                child: Text("ok".tr(),
                    style: Theme.of(context).textTheme.headline6),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    });
  }
}
