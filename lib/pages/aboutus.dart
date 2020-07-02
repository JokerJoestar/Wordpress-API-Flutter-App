import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wp_flutter_app/variables/constants.dart' as con;
import 'package:easy_localization/easy_localization.dart';
import 'package:wp_flutter_app/widgets/customscaffold.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return CustomScaffold(bodyWidget: aboutUsWidget(), pageIndex: 4, appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: con.AppBarBackgroundColor,
            centerTitle: true,
            title: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft)))));
  }

  Widget aboutUsWidget() {
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
                  sectionHeader("about_us".tr()),
                  Padding(
                      padding: EdgeInsets.only(top: 5, left: 8, right: 8),
                      child: RichText(
                          softWrap: true,
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 17, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(text: con.siteInformation.description),
                                TextSpan(
                                    text: "\n${'manager'.tr()}: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            fontSize: 17, color: Colors.black)),
                                TextSpan(text: con.siteInformation.manager)
                              ]))),
                  commColumnWidget(),
                  locationColumnWidget(),
                  socialMediaColumnWidget()
                ],
              )))
    ]);
  }

  Widget sectionHeader(String headerTitle) {
    return Column(children: [
      Center(
          child: Text(
        headerTitle,
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 23),
        textAlign: TextAlign.center,
      )),
      Container(height: 1, color: Colors.black)
    ]);
  }

  Widget locationColumnWidget() {
    if (con.siteInformation.address != null && con.siteInformation.address.isNotEmpty) {
      List<String> textAddress = con.siteInformation.address.split(",");
      List<Widget> list = new List<Widget>();

      for (var i = 0; i < con.siteInformation.emails.length; i++) {
        list.add(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(textAddress[i].trim(),
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontSize: 18, color: Colors.black))
        ]));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader("location".tr()),
          Padding(
              padding: EdgeInsets.only(top: 5, left: 8, right: 8),
              child: GestureDetector(
                  onTap: () {
                    if(con.siteInformation.googleMapLocation != null && con.siteInformation.googleMapLocation.isNotEmpty)
                      launch(con.siteInformation.googleMapLocation);
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list)))
        ],
      );
    } else
      return Container();
  }

  Widget socialMediaColumnWidget() {
    if (con.siteInformation.socialMedia != null &&
        con.siteInformation.socialMedia.length > 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        sectionHeader("social_media".tr()),
        socialMediaWidgetList()
      ]);
    } else
      return Container();
  }

  Widget socialMediaWidgetList() {
    List<Widget> list = new List<Widget>();

    var smList = con.siteInformation.socialMedia;

    for (var i = 0; i < smList.length; i++) {
      list.add(
        IconButton(
          splashRadius: 22,
            padding: EdgeInsets.only(right: 1),
            iconSize: 23,
            icon: Icon((smList[i].icon), color: con.AppBarBackgroundColor),
            onPressed: () {
              launch(smList[i].link);
            }),
      );
    }

    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }

  Widget commColumnWidget() {
    if (con.siteInformation.emails != null &&
        con.siteInformation.emails.length > 0) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [sectionHeader("contact".tr()), commWidgetList()]);
    } else
      return Container();
  }

  Widget commWidgetList() {
    List<Widget> list = new List<Widget>();

    for (var i = 0; i < con.siteInformation.emails.length; i++) {
      list.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(con.siteInformation.emails[i].title,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 18, color: Colors.black)),
        GestureDetector(
            onTap: () {
              launch(
                  'mailto:${con.siteInformation.emails[i].link}?subject=&body=');
            },
            child: Text(con.siteInformation.emails[i].link,
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 17, color: con.AppBarBackgroundColor))),
        Container(height: 6)
      ]));
    }

    return Padding(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }
}
