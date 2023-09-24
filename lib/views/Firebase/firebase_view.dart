import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);
  static const routeName = "/Firebase_view";

  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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
                title: Text("Firebase Connection"),
                backgroundColor: AppColors.primary,
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
            home: FirebaseConnected(),
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

class FirebaseConnected extends StatelessWidget {
  const FirebaseConnected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase'),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Text(
            'Successfully connected to firebase!',
            style: kButtonLightTextStyle
          ),
        )
    );
  }
}