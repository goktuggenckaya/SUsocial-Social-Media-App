import 'dart:io';
import 'package:cs310group1/addPost/post_screen.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/views/FeedView/editpostpic.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/HomePage/homepage.dart';
import 'package:cs310group1/views/Profile/profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310group1/services/comment_database.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class editPost extends StatefulWidget {
  Post post_item;
  editPost({Key? key, required this.post_item}) : super(key: key);

  @override
  _editPostState createState() => _editPostState();
}

class _editPostState extends State<editPost> {
  TextEditingController nameController = TextEditingController();

  Future<void> showAlertDialog(String post_id,String field) async {
    TextEditingController nameController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Enter new " + field, textAlign: TextAlign.center,),
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
                      OutlineButton(onPressed:() {
                        print(nameController.text);
                        FirebaseFirestore.instance.collection('posts').doc(post_id).update({field: nameController.text});
                      }, child:Text("Save"))
                    ]
                ),
              )
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('SuSocial'),
          backgroundColor: AppColors.W_appBarBackground
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
        child:ListView(
            children: [
              SizedBox(height: 30,),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.post_item.image_link!= "" ?
                    buildImage(widget.post_item.image_link!, widget.post_item.post_id!):
                    Text("What are you feeling?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),),

                    SizedBox(height: 10,),
                    Container(
                        margin:EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        width: 350.0,
                        height:100.0,
                        child:buildCaption(widget.post_item.caption!,widget.post_item.post_id!)
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: ()
                    {
                      Navigator.pop(context);
                    }, child: Icon(Icons.save))
                  ]
              )
            ]
        ),


      ),

    );
  }
  Widget buildCaption(String caption, String postid) => Container(

    child: Wrap(
        children: [
          Text(
            caption,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          IconButton(onPressed: () {showAlertDialog(postid, "caption");}, icon: Icon(Icons.edit))]
    ),
  );
  Widget buildImage(String image_link, String postid) => Container(

    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(image:NetworkImage(image_link),height: 400,width: 400,),
          IconButton(
              onPressed: ()  {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => EditPostPic(postid: postid)
                    ));}
              , icon: Icon(Icons.edit)),
        ]
    ),
  );
}
