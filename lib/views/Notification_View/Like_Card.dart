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
import "../login/login_with_authentication.dart";
import "package:cs310group1/utils/user_preferences.dart";

class LikeCard extends StatefulWidget {
  String? like_id;
  LikeCard ({ Key? key, this.like_id }): super(key: key);
  @override
  _LikeCardState createState() => _LikeCardState();
}



class _LikeCardState extends State<LikeCard> {
  String? username;
  get comments => CommentsData();

  Widget build(BuildContext context) {
    for (var i = 0; i < comments!.length; i++) {
      if(comments[i].user_id == widget.like_id) comments[i].username = username;
    }
      return Card(
          margin: Dimen.searchAppBarPadding,
          color: AppColors.notifCardColor,
          child:
          Text(
            "${username} has liked your post.",
            textAlign: TextAlign.center,
            style: newstyle,
          )
      );

  }
}