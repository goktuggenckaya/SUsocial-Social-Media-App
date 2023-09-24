// ignore_for_file: file_names
import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/views/Welcome_Page/welcome.dart';
import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:cs310group1/views/login/reset.dart';
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

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/login";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}


class _DeleteScreenState extends State<DeleteScreen> {
  String _message = '';
  int attemptCount = 0;
  String mail = "";
  String pass = "";
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService auth=AuthService();
  AuthService auth2=AuthService();
  static const routeName = "/login";

  @override
  void initState() {
    super.initState();
  }

   Future deleteUserAccount(String mail, String pass) async {
    User? user = await _auth.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(email:mail, password:pass);
    if(user!=null){
      await user.reauthenticateWithCredential(credential).then((value) {
        value.user!.delete().then((res) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(analytics: widget.analytics, observer: widget.observer),
              ));
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(
              'Account Deleted')));
              auth.signOut();
        });
        }
        ).catchError((onError)=>
          ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(
          'Credential Error'))));
      }
     }

  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user!=null){
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Delete Account"),
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

                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password: ',
                          hintText: 'Enter your password'
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        pass = value ?? "";
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          deleteUserAccount(mail,pass);

                        }
                        //Will navigate to the homepage screen that will be implemented later
                        // ignore: avoid_print
                        print('Delete account button pressed!');
                      },
                      child: const Text('Delete Account'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Don't have an account yet?   "),
                        InkWell(
                          onTap: () {
                            //Navigate to the signup screen
                            Navigator.of(context).pushNamed(
                                SignupScreen.routeName);
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
                    Text(
                      _message,
                      style: TextStyle(
                        color: AppColors.captionColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return LoginScreen(analytics: widget.analytics, observer: widget.observer);
      //Show Feed Screen
    }
  }
}

