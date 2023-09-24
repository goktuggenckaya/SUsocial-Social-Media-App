import 'package:flutter/material.dart';

class Dimen {
  static const double parentMargin = 16.0;
  static const double regularMargin = 8.0;
  static const double largeMargin = 20.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusRounded = 20.0;
  static const double textFieldHeight = 32.0;

  //static get regularPadding => EdgeInsets.all(parentMargin);
  static get loginPagePadding => EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0);
  static get signupPagePadding => EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0);
  static get welcomePagePadding => EdgeInsets.fromLTRB(30.0,100.0,30.0,100.0);
  static get searchAppBarPadding => EdgeInsets.fromLTRB(10, 4, 10, 4);
  static get left5Padding => EdgeInsets.only(left: 5);
}
