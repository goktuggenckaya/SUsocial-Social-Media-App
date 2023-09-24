import 'dart:io';
import 'package:cs310group1/addPost/post_screen.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310group1/services/comment_database.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  AddImage ({ Key? key,required this.analytics, required this.observer }): super(key: key);
  @override
  _AddImage createState() => _AddImage();
}

class _AddImage extends State<AddImage> {
  File? image;
  Future pick_image(ImageSource source )async {
    try{
      final image = await ImagePicker().pickImage(source:source);
      if (image == null){
        return;
      }
      final imageTemporary = File(image.path);
      setState( () => this.image= imageTemporary);
    } on PlatformException catch(e){
      print("FAIL: $e");
    }
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
        style:ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          primary: Colors.white,
          onPrimary:Colors.black,
          textStyle: TextStyle(fontSize:20),
        ),
        child: Row(
            children:[
              Icon(icon, size:28),
              const SizedBox(width:16),
              Text(title),
            ]
        ),
        onPressed : onClicked,
      );

  void next_page(img){
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => NewPostScreen(image: img, analytics: widget.analytics,observer:widget.observer),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
        child: Container(

            child: ListView(
                children: [

                  Spacer(),
                  image!= null ? Image.file(image!,  width : 400 , height: 400) : Text(" "),
                  const SizedBox(height:24),
                  const Text(
                      'Upload Image',
                      style :TextStyle(
                        fontSize:32,
                        fontWeight:FontWeight.bold,
                      )
                  ) ,
                  const SizedBox(height:48),
                  buildButton(
                    title:"Pick Gallery",
                    icon:Icons.image_outlined,
                    onClicked: () => pick_image(ImageSource.gallery),
                  ),
                  const SizedBox(height:48),
                  buildButton(
                    title:"Pick Camera",
                    icon:Icons.camera_outlined,
                    onClicked: () => pick_image(ImageSource.camera),
                  ),
                  const SizedBox(height:48),
                  ElevatedButton(

                    onPressed : () => next_page(image), child: Text("NEXT"),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFAF2625)),)
                ]
            )

        ),
      ),


    );

  }
}