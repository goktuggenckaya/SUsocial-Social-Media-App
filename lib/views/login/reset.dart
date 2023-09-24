// ignore_for_file: file_names
import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:cs310group1/views/HomePage/homepage.dart';
import 'package:cs310group1/views/signup/signup_with_authentication.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:cs310group1/services/post_database.dart';
import 'package:provider/provider.dart';

User? _userFromFirebase(User? user) {
  return user ?? null;
}

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/reset";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _ResetScreenState createState() => _ResetScreenState();
}


class _ResetScreenState extends State<ResetScreen> {
  String _message = '';
  int attemptCount = 0;
  String mail = "";

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService auth=AuthService();
  AuthService auth2=AuthService();
  static const routeName = "/reset";

  @override
  void initState() {
    super.initState();
  }

  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user==null){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Reset Password"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Padding(
        padding: Dimen.loginPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email: ',
                              hintText: 'Enter your email address'
                          ),
                          validator: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'Please enter your e-mail';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'The e-mail address is not valid';
                              }
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            mail = value ?? "";
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(child: Text('Reset Password'),
                          onPressed: () {
                        _auth.sendPasswordResetEmail(email: mail); Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar
                          (SnackBar(content: Text('Request sended, please check your email')));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    return FeedView(analytics: widget.analytics, observer: widget.observer);
    //Show Feed Screen
    }
  }
}
