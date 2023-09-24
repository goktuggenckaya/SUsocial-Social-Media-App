import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/services/report_database.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/views/Profile/edit_profile_page.dart';
import 'package:cs310group1/views/login/deleteaccount.dart';
import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//just a widget for the profile page's app bar
AppBar buildAppBar2(BuildContext context,analytics,observer,userid) {
  AuthService auth = AuthService();
  Future report() async {
    TextEditingController nameController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Why are you reporting this user?"),
              content: Container(
                height: 150,
                child: Column(
                    children:[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      OutlinedButton(onPressed:() {
                        if(nameController.text == null){
                          var newreport = ReportsData().addReport(userid, "", "");
                        }
                        else {
                          var newreport = ReportsData().addReport(userid, "", nameController.text);
                        }
                      },
                        child:Text("Report"),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red), foregroundColor: MaterialStateProperty.all<Color>(Colors.white) ),)
                    ]
                ),
              )
          );
        });
  }
  return AppBar(
    leading: IconButton(
      onPressed: () {
        auth.signOut();
      },
      icon: Icon(Icons.logout),
    ),
    backgroundColor: AppColors.W_appBarBackground,
    elevation: 10,
    actions: [
      IconButton(
        iconSize: 25,
        onPressed: report,
        icon: Icon(Icons.report),
        color: Colors.white,
      )
    ],

  );




}