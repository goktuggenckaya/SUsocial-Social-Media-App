// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/login";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
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

  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  Future facebookLogin() async {
    try {
      UserCredential result = await auth2.signInWithFacebook();
      User user = result.user!;
      dynamic userid = user.uid;
      if(userid != null){
        FirebaseFirestore.instance.collection('users').doc(userid).update({'disabled': false});
        dynamic followinglist = [];
        dynamic followerslist = [];
        await FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (doc.id == userid){
              followinglist = doc["following"];
              followerslist = doc["followers"];
            }
          });
        });
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        print(followerslist);
        print(followinglist);
        await FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (followerslist.contains(doc.id)){
              dynamic fl = doc["following"];
              fl.add(userid);
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({'following': fl});
            }
            if (followinglist.contains(doc.id)){
              dynamic fl2 = doc["followers"];
              fl2.add(userid);
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({'followers': fl2});
            }
          });
        });

      }
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        setmessage("user-not-found");
      }
      else if (e.code == 'wrong-password') {
        setmessage('Please check your password');
      }
    }catch (e) {
      setmessage(e.toString());
      return null;
    }
  }

  Future loginUser(String mail, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      dynamic userid = user.uid;
      if(userid != null){
        FirebaseFirestore.instance.collection('users').doc(userid).update({'disabled': false});
        dynamic followinglist = [];
        dynamic followerslist = [];
        await FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (doc.id == userid){
              followinglist = doc["following"];
              followerslist = doc["followers"];
            }
          });
        });
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        print(followerslist);
        print(followinglist);
        await FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (followerslist.contains(doc.id)){
              dynamic fl = doc["following"];
              fl.add(userid);
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({'following': fl});
            }
            if (followinglist.contains(doc.id)){
              dynamic fl2 = doc["followers"];
              fl2.add(userid);
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({'followers': fl2});
            }
          });
        });

      }
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        setmessage("user-not-found");
      }
      else if (e.code == 'wrong-password') {
        setmessage('Please check your password');
      }
    }catch (e) {
      setmessage(e.toString());
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user==null){
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Login"),
          backgroundColor: AppColors.appBarColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
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

                            loginUser(mail,pass);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(
                                'Logging in')));
                          }
                          //Will navigate to the homepage screen that will be implemented later
                          // ignore: avoid_print
                          print('Login button pressed!');
                        },
                        child: const Text('Login'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(child: Text('Forgot your password?  '),onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetScreen(analytics: widget.analytics, observer: widget.observer),
                                ));
                          }),
                        ],
                      ),
                      Text(
                        _message,
                        style: TextStyle(
                          color: AppColors.captionColor,
                        ),
                      ),
                      SignInButton(
                        Buttons.GoogleDark,
                        onPressed: auth2.googleSignIn,
                      ),
                      SizedBox(height: 10),
                      SignInButton(Buttons.Facebook, onPressed: facebookLogin),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [OutlinedButton(
                            onPressed: () {
                              FirebaseCrashlytics.instance.crash();
                            },
                            child: Text('button is pressed program crashes')
                        ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return FeedView(analytics: widget.analytics, observer: widget.observer);
      //Show Feed Screen
    }
  }
}
