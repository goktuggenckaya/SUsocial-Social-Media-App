import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/utils/styles.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/welcome";

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:AppColors.primary,
      body: Padding(
          padding: Dimen.welcomePagePadding,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Text(
                  "Welcome to our SUSocial application",// name can be changed to application name
                  textAlign: TextAlign.center,
                  style: kHeadingTextStyle,
                ),
                const Icon(
                  Icons.coffee,
                  color: AppColors.secondary,
                  size: 50.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                    widget.analytics.setCurrentScreen(screenName: 'Login Screen');
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColor)),
                  child: Text(
                    "Tap to continue",
                    style: kButtonLightTextStyle,
                  ),
                ),
              ],
          ),
      ),
    );
  }
}