// ignore_for_file: file_names
/*
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:cs310group1/views/Firebase/firebase_view.dart';
import 'package:cs310group1/views/signup/signupView.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/*
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
*/
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/login";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();
  String mail = '';
  String password = '';
  void loginButtonPressed() {
    // ignore: avoid_print
    print('Login button pressed');
    auth.loginWithMailAndPass(mail, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Padding(
        padding: Dimen.loginPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email: ',
                  hintText: 'Enter your email address'
              ),
              validator: (String? value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return 'Please enter your e-mail';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'The e-mail address is not valid';
                  }
                  return null;
                }
              },
              onSaved: (String? value) {
                if(value != null) {
                  mail = value;
                  print(value);
                }
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password: ',
                  hintText: 'Enter your password'
              ),/*
              validator: (value) {
                if(value.isEmpty) {
                  return 'Please enter your password';
                }
                if(value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              onSaved: (String? value) {
                password = value!;
              },*/
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: loginButtonPressed,
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Don't have an account yet?   "),
                InkWell(
                  onTap: () {
                    //Navigate to the singup screen
                    Navigator.of(context).pushNamed(SignupScreen.routeName);
                    widget.analytics.setCurrentScreen(screenName: 'Sign-Up Page');
                  },
                  child: const Text(
                    "Sign Up!",
                    style: TextStyle(color: AppColors.inkWellColor),
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
                const Text("Forgot your password?   "),
                InkWell(
                  onTap: () {
                    //Navigate to the password reset page which is not implemented yet
                  },
                  child: const Text(
                    "Change Password!",
                    style: TextStyle(color: AppColors.inkWellColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SignInButton(
                Buttons.GoogleDark,
                onPressed: auth.googleSignIn,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [OutlinedButton(
                    onPressed: (){
                      FirebaseCrashlytics.instance.crash();
                    },
                    child:Text('button is pressed program crashes')
                )]
            )
          ],
        ),
      ),
    );
  }
}
*/
