import 'package:flutter/material.dart';

class NoPageTransition extends PageRouteBuilder {
  final Widget page;
  NoPageTransition({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
}