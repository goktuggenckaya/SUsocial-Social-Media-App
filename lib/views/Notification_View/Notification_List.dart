// ignore_for_file: file_names

import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/views/Notification_View/Notification_View.dart';
import 'package:cs310group1/views/Notification_View/Notification_Card.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/services/post_database.dart';
import 'package:cs310group1/services/comment_database.dart';



class NotifList extends StatefulWidget {
  @override
  _NotifListState createState() => _NotifListState();
}

class _NotifListState extends State<NotifList> {
  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>?>(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if(comments?.length == null) {
      return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('There are no comments!'),
            ],
          )
      );
    }
    else {
      return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: comments?.length,
          itemBuilder: (context, index) {
            print(uid);
            print(comments![index].owner_id);
            if(uid == comments![index].owner_id) {
              return NotifCard(comment_item: comments![index]);
            }
            else {
              return SizedBox(height: 0);
            }
          }
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    }
  }
}




