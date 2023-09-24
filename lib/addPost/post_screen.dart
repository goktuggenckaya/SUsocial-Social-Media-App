import 'dart:io';
import 'package:cs310group1/services/post_database.dart';
import 'package:cs310group1/views/HomePage/homepage.dart';
import 'package:cs310group1/views/Profile/profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewPostScreen extends StatefulWidget {
  var image;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  NewPostScreen({ Key? key, required this.image, required this.analytics, required this.observer }): super(key: key);
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {

  TextEditingController nameController = TextEditingController();
  addNewPost(String text, File? image) async {
    dynamic url = null;
    if(image != null){
      print("path is");
      print(image.path);
      var ref = firebase_storage.FirebaseStorage.instance.ref('images/' + image.path);
      UploadTask task = ref.putFile(image);
      url = await (await task).ref.getDownloadURL();
    }
    dynamic comments = [];
    dynamic image_link = url;
    dynamic like_id = [];
    dynamic caption = text;
    DateTime now = DateTime.now();
    var result = PostsData().addPost(comments, image_link, like_id, caption, now, "");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedView(analytics: widget.analytics, observer: widget.observer,),
        ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
            child:ListView(
              children: [
                SizedBox(height: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.image!= null ? Image.file(widget.image!,  width : 400 , height: 400) : Text("What are you feeling?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),),
                    SizedBox(height: 20,),
                    Container(
                      margin:EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      width: 300.0,
                      height: 50.0,
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Add New Caption',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('What is this post about?'),
                    SizedBox(height: 10),
                    Container(
                      height: 35,
                      padding: EdgeInsets.fromLTRB(40, 3, 40, 0),
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                nameController.text += ' #Sports';
                              });
                            },
                            child: const Text("Sports"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                nameController.text += ' #Ride';
                              });
                            },
                            child: const Text("Ride"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                nameController.text += ' #Study';
                              });
                            },
                            child: const Text("Study"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                nameController.text += ' #Movies';
                              });
                            },
                            child: const Text("Movies"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                nameController.text += ' #Meal';
                              });
                            },
                            child: const Text("Meal"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                nameController.text += ' #Events';
                              });
                            },
                            child: const Text("Events"),
                          ),
                        ],
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 25.0,
                      child:RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Share'),//Icon(Icons.add_comment, size: 20.0, color: Colors.white),
                        onPressed: (){
                          addNewPost(nameController.text, widget.image);
                        },
                      ),
                    ),
                  ],
                ),

    ]
            ),
          ),
    );
  }

}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }