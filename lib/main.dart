import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:cs310group1/views/Profile/followers.dart';
import 'package:cs310group1/views/Profile/following.dart';
import 'package:cs310group1/views/Profile/numbers_widget.dart';
import 'package:cs310group1/views/Welcome_Page/welcome.dart';
import 'package:cs310group1/views/Firebase/firebase_view.dart';
import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:cs310group1/views/searchExplore/explore_view.dart';
import 'package:cs310group1/views/signup/signup_with_authentication.dart';
import 'package:cs310group1/views/walkthrough/walkthrough.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cs310group1/services/post_database.dart';

bool isShown = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isShown = prefs.getBool('isShown') ?? false;
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Firebase Connection"),
                backgroundColor:AppColors.W_appBarBackground ,
              ),
              body: Center(
                  child:
                  Column(
                    children: [
                      Text('No Firebase Connection: ${snapshot.error.toString()}',
                      ),
                    ],
                  )
              ),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: AppBase(analytics: analytics, observer: observer,),
          );
        }
        return MaterialApp(
          home: Center(
            child: Text('Connecting to Firebase',
                style: kButtonLightTextStyle
            ),
          ),
        );
      },
    );
  }
}

class AppBase extends StatelessWidget {
  const AppBase({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Future<void> _setCurrentScreen() async {
    analytics.logAppOpen();
    if(!isShown) {
      analytics.logTutorialBegin();
      analytics.setCurrentScreen(screenName: 'Walktrough: Sports');
    }
    else{
      analytics.setCurrentScreen(screenName: 'Welcome Page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        initialRoute: isShown ? WelcomePage.routeName : Walkthrough.routeName,
        routes: {
          Walkthrough.routeName: (context) => Walkthrough(analytics: analytics, observer: observer),
          WelcomePage.routeName: (context) => WelcomePage(analytics: analytics, observer: observer),
          LoginScreen.routeName: (context) => LoginScreen(analytics: analytics, observer: observer),
          SignupScreen.routeName: (context) => SignupScreen(analytics: analytics, observer: observer),
          MyFirebaseApp.routeName: (context) => MyFirebaseApp(),
          ExploreScreen.routeName: (context) => ExploreScreen(analytics: analytics,observer:observer),
        },
      ),
    );
  }
}