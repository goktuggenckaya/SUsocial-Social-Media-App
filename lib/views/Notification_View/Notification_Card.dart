// ignore_for_file: file_names

import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/services/comment_database.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/services/post_database.dart';
import 'package:provider/provider.dart';
import "../login/login_with_authentication.dart";
import "package:cs310group1/utils/user_preferences.dart";

class NotifCard extends StatefulWidget {
  final Comment comment_item;
  NotifCard ({ Key? key, required this.comment_item}): super(key: key);
  @override
  _NotifCardState createState() => _NotifCardState();
}



class _NotifCardState extends State<NotifCard> {
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: Dimen.searchAppBarPadding,
        color: AppColors.notifCardColor,
        child:
        Text(
          "${widget.comment_item!.username} has commented on your post: ${widget.comment_item!.comment}",
          textAlign: TextAlign.center,
          style: newstyle,
        )
    );
  }
}
