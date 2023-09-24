// ignore_for_file: file_names

import 'package:cs310group1/services/user_database.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:provider/provider.dart';

User? _userFromFirebase(User? user) {
  return user ?? null;
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/signup";

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _SignupScreenState createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
  String _message = '';
  int attemptCount = 0;
  String phone = '';
  String? name;
  String surname = '';
  String username = '';
  String mail = '';
  String pass = '';
  String confirmed = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService auth = AuthService();

  addNewUser(String userid) async {
    dynamic email = mail;
    dynamic about = "";
    dynamic followers = [];
    dynamic image_path = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
    dynamic following = [];
    dynamic Name = "$name " + "$surname";
    dynamic Username = "$name"+"$surname";
    dynamic pendingfollowers = [];
    dynamic private = false;
    dynamic disabled = false;
    var result = UsersData(userid).addUser(about, email, followers, following, image_path, Name, Username, pendingfollowers, private, disabled);
  }

  Future signupWithMailAndPass(String mail, String pass,String confirmed) async {
    if(pass!=confirmed) {
      setmessage('Password and confirmed password does not match!');
    }
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      print(user.uid);
      if(user!=FirebaseAuthException){
        addNewUser(user.uid);
      }
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use') {
        setmessage('This email is already in use');
      }
      else if(e.code == 'weak-password') {
        setmessage('Weak password, add uppercase, lowercase, digit, special character, emoji, etc.');
      }
    }catch (e) {
      print(e.toString());
      return null;
    }
  }
  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
  }
  static const routeName = "/signup";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user==null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sign Up"),
          backgroundColor: AppColors.appBarColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimen.signupPagePadding,
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
                              decoration: const InputDecoration(
                                  labelText: 'Name: ',
                                  hintText: 'Enter your name'
                              ),
                              onSaved: (String? value) {
                                name = value ?? "";
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Surname: ',
                            hintText: 'Enter your surname'
                        ),
                        onSaved: (String? value) {
                          surname = value ?? "";
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email: ',
                            hintText: 'Enter your email address'
                        ),
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              setmessage('Please enter your e-mail');
                            }
                            if (!EmailValidator.validate(value)) {
                              setmessage('The e-mail address is not valid');
                            }
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          mail = value ?? "";
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Phone: ',
                            hintText: 'Enter your phone number'
                        ),
                        onSaved: (String? value) {
                          phone = value ?? "";
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password: ',
                            hintText: 'Enter your password'
                        ),
                        onSaved: (String? value) {
                          pass = value ?? "";
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password: ',
                            hintText: 'Confirm your password'
                        ),
                        onSaved: (String? value) {
                          confirmed = value ?? "";
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            signupWithMailAndPass(mail, pass, confirmed);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text(_message)));
                          }

                          /*Only prints a message; later, it will check the validity of the inputs and
                make necessary changes to firebase and navigate to the interest survey page if sign-up is successful*/
                          // ignore: avoid_print
                          print("Signup button pressed");
                        },
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Already a member?   "),
                          InkWell(
                            onTap: () {
                              //Navigate to the login screen
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: AppColors.inkWellColor),
                            ),
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
    }
    else{
      return LoginScreen(analytics: widget.analytics, observer: widget.observer);
    }
  }
}