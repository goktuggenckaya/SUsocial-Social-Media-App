import 'package:cs310group1/services/post_database.dart';
import 'package:cs310group1/services/report_database.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/Profile/user_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310group1/services/comment_database.dart';
import 'package:like_button/like_button.dart';
import 'package:intl/intl.dart';

import 'edit_post.dart';

class PostTile extends StatefulWidget {
  Post post_item = Post("",[],"",[],"","","", "");
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  PostTile ({ Key? key, required this.post_item,required this.analytics, required this.observer }): super(key: key);
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  TextEditingController nameController = TextEditingController();
  List? images;
  dynamic userid = FirebaseAuth.instance.currentUser?.uid;


  addNewComment(new_comment) async{
    String? neww = new_comment;
    var username = "";
    if(neww!.isEmpty){
      print("ENTER A COMMENT");
    }
    else{
      dynamic userid = "";
      if(FirebaseAuth.instance.currentUser != null){
        userid = FirebaseAuth.instance.currentUser?.uid;
      }
      print("USER ID: $userid");
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == userid){
            username = doc["username"];
            print(username);
            DateTime now = DateTime.now();
            var result = CommentsData(uid: userid, post_id: widget.post_item.post_id, user_name:username, owner_id: widget.post_item.user_id, date:now).addComment(neww);
          }
        });
      });
      var postid = widget.post_item.post_id;
      print("post id : $postid");
      nameController.clear();
    }
  }

  bool? Liked(){
    List? like_array = widget.post_item.like_id;
    dynamic userid = "";
    if(FirebaseAuth.instance.currentUser != null){
      userid = FirebaseAuth.instance.currentUser?.uid;
    }
    if(like_array!.contains(userid)){
      return true;
    }
    else {
      return false;
    }
  }
  deletePost() async {

    dynamic postid = widget.post_item.post_id;
    FirebaseFirestore.instance.collection("posts").doc(postid).delete();
  }

  Future<bool> LikeButtonTapped(bool isLiked) async{
    List? like_array = widget.post_item.like_id;
    final userid =  await FirebaseAuth.instance.currentUser?.uid;
    if(like_array != null && like_array.contains(userid)){
      like_array.remove(userid);
      FirebaseFirestore.instance.collection('posts').doc(
          widget.post_item.post_id).update({'like_id': like_array});
      return Future.value(false);
    }
    else {
      if (like_array == null) {
        like_array = [userid];
      }
      else {
        like_array.add(userid);
        FirebaseFirestore.instance.collection('posts').doc(
            widget.post_item.post_id).update({'like_id': like_array});
        return Future.value(true);
      }
    }
    return Future.value(false);

  }
  bool showWidget = false;

  Future report() async {
    TextEditingController nameController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Why are you reporting this post?"),
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
                          var newreport = ReportsData().addReport(widget.post_item.user_id, widget.post_item.post_id, "");
                        }
                        else {
                          var newreport = ReportsData().addReport(widget.post_item.user_id, widget.post_item.post_id, nameController.text);
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

  @override
  Widget build(BuildContext context) {
    dynamic? username;

    if (widget.post_item.post_id == "") {
      return Container();
    }
    else if (widget.post_item.reshared_by == null || widget.post_item.reshared_by == "" ) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
          child: Column(
              children: [
                ListTile(
                  title: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                          itemCount: streamSnapshot.data != null
                              ? streamSnapshot.data?.docs.length
                              : 0,
                          itemBuilder: (ctx, index) =>
                              Container(

                                  child: (streamSnapshot.data != null &&
                                      streamSnapshot.data?.docs[index].id ==
                                          widget.post_item.user_id) ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          streamSnapshot.data
                                              ?.docs[index]['username'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onTap: () =>
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfilePage(
                                                        user_id: streamSnapshot
                                                            .data?.docs[index]
                                                            .id,
                                                        private: streamSnapshot
                                                            .data?.docs[index]["private"],
                                                        followerlist:streamSnapshot
                                                            .data?.docs[index]["followers"],
                                                        analytics: widget
                                                            .analytics,
                                                        observer: widget
                                                            .observer),
                                              ))
                                        },
                                      ),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(
                                            widget.post_item.date.toDate())
                                            .toString(),
                                        style: TextStyle(

                                            color: Colors.black38
                                        ),
                                      )
                                    ],
                                  ) :
                                  Container()
                              )
                      );
                    },
                  ),
                  leading: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 6.0, 0.0, 0.0),
                          width: 50.0,
                          height: 50.0,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context, AsyncSnapshot<
                                QuerySnapshot> streamSnapshot) {
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: streamSnapshot.data != null
                                      ? streamSnapshot.data?.docs.length
                                      : 0,
                                  itemBuilder: (ctx, index) =>
                                      Container(

                                          child: (streamSnapshot.data != null &&
                                              streamSnapshot.data?.docs[index]
                                                  .id ==
                                                  widget.post_item.user_id) ?
                                          CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  streamSnapshot.data
                                                      ?.docs[index]['image_path'] ??
                                                      " "),
                                              radius: 25.0) :
                                          Container()
                                      )
                              );
                            },
                          ),

                        ),
                      ]),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(30.0, 6.0, 20.0, 0.0),
                    child:
                    Container(
                        child: (widget.post_item.image_link != "") ?
                        Image(
                            image: NetworkImage(widget.post_item.image_link ??
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg")
                        ) :
                        Container()
                    )
                ),
                SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: (widget.post_item.caption != "") ?
                              Text(widget.post_item.caption ?? "") :
                              Container()
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              LikeButton(
                                  size: 25.0,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  likeCount: widget.post_item.like_id != null
                                      ? widget.post_item.like_id?.length
                                      : 0,
                                  onTap: LikeButtonTapped,
                                  isLiked: Liked()
                              ),
                              IconButton(
                                  iconSize: 23,
                                  color: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      showWidget = !showWidget;
                                    });
                                    print(showWidget);
                                  },
                                  icon: Icon(Icons.add_comment)),
                              Spacer(),
                              Column(

                                children: [
                                  Container(
                                      child: (widget.post_item.user_id ==
                                          userid) ?
                                      IconButton(
                                        iconSize: 23,
                                        onPressed: deletePost,
                                        icon: Icon(Icons.delete),
                                        color: Colors.grey,
                                      ) :
                                      Container()
                                  )
                                ],),

                              IconButton(
                                iconSize: 23,
                                onPressed: report,
                                icon: Icon(Icons.report),
                                color: Colors.grey,
                              ),
                              Container(
                                  child: (widget.post_item.user_id ==
                                      userid) ?
                                  IconButton(
                                    iconSize: 23,
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => editPost(post_item: widget.post_item),
                                          ));
                                    },
                                    icon: Icon(Icons.edit),
                                    color: Colors.grey,
                                  ) :
                                  Container()
                              ),
                              Container(
                                  child: (widget.post_item.user_id !=
                                      userid) ?
                                  IconButton(
                                    iconSize: 23,
                                    onPressed: (){
                                      PostsData().resharePost(widget.post_item.user_id, widget.post_item.comments, widget.post_item.image_link, widget.post_item.like_id, widget.post_item.caption, widget.post_item.date);
                                    },
                                    icon: Icon(Icons.subdirectory_arrow_left),
                                    color: Colors.grey,
                                  ) :
                                  Container()
                              )
                            ],
                          ),
                        ],
                      )
                  ),
                ),
                showWidget ?
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('comments')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          return ListView.builder(
                            //physics: NeverScrollableScrollPhysics(),

                              clipBehavior: Clip.antiAlias,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10),
                              itemCount: streamSnapshot.data != null
                                  ? streamSnapshot.data?.docs.length
                                  : 0,
                              itemBuilder: (ctx, index) =>
                                  Container(
                                      child: (streamSnapshot.data != null &&
                                          streamSnapshot.data
                                              ?.docs[index]['post_id'] ==
                                              widget.post_item.post_id) ?
                                      Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(streamSnapshot.data
                                                      ?.docs[index]['username'],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold
                                                      )
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    DateFormat.yMMMd()
                                                        .format(
                                                        streamSnapshot.data
                                                            ?.docs[index]['date']
                                                            .toDate())
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        color: Colors.black38
                                                    ),
                                                    textAlign: TextAlign
                                                        .justify,
                                                  )
                                                ],
                                              ),
                                              Container(width: 10),
                                              Container(
                                                child: Text(streamSnapshot.data
                                                    ?.docs[index]['comment'],
                                                    textAlign: TextAlign
                                                        .justify),
                                              ),
                                              SizedBox(height: 5,)
                                            ],
                                          )) :
                                      Container()
                                  )
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          width: 150.0,
                          height: 25.0,
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'New Comment',
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 50.0,
                          height: 25.0,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Icon(
                                Icons.add_comment, size: 20.0, color: Colors
                                .white),
                            onPressed: () {
                              addNewComment(nameController.text);
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ) :
                Container()
              ]
          ),
        ),
      );
    }
    else{
      String? username1;
      getusername() async{
        FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (doc.id == widget.post_item.reshared_by){
              username1 = doc["username"];
              print(username1);
            }
          });
        });
      }
      getusername();
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
          child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                          itemCount: streamSnapshot.data != null
                              ? streamSnapshot.data?.docs.length
                              : 0,
                          itemBuilder: (ctx, index) =>
                              Container(

                                  child: (streamSnapshot.data != null &&
                                      streamSnapshot.data?.docs[index].id ==
                                          widget.post_item.reshared_by) ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Text("Reposted by "),
                                      InkWell(
                                        child: Text(
                                          streamSnapshot.data
                                              ?.docs[index]['username'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onTap: () =>
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfilePage(
                                                        user_id: streamSnapshot
                                                            .data?.docs[index]
                                                            .id,
                                                        private: streamSnapshot
                                                            .data?.docs[index]["private"],
                                                        followerlist:streamSnapshot
                                                            .data?.docs[index]["followers"],
                                                        analytics: widget
                                                            .analytics,
                                                        observer: widget
                                                            .observer),
                                              ))
                                        },
                                      ),

                                    ],
                                  ) :
                                  Container()
                              )
                      );
                    },
                  ),
                ),
                ListTile(
                  title: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                          itemCount: streamSnapshot.data != null
                              ? streamSnapshot.data?.docs.length
                              : 0,
                          itemBuilder: (ctx, index) =>
                              Container(

                                  child: (streamSnapshot.data != null &&
                                      streamSnapshot.data?.docs[index].id ==
                                          widget.post_item.user_id) ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          streamSnapshot.data
                                              ?.docs[index]['username'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onTap: () =>
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfilePage(
                                                        user_id: streamSnapshot
                                                            .data?.docs[index]
                                                            .id,
                                                        private: streamSnapshot
                                                            .data?.docs[index]["private"],
                                                        followerlist:streamSnapshot
                                                            .data?.docs[index]["followers"],
                                                        analytics: widget
                                                            .analytics,
                                                        observer: widget
                                                            .observer),
                                              ))
                                        },
                                      ),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(
                                            widget.post_item.date.toDate())
                                            .toString(),
                                        style: TextStyle(

                                            color: Colors.black38
                                        ),
                                      )
                                    ],
                                  ) :
                                  Container()
                              )
                      );
                    },
                  ),
                  leading: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 6.0, 0.0, 0.0),
                          width: 50.0,
                          height: 50.0,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context, AsyncSnapshot<
                                QuerySnapshot> streamSnapshot) {
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: streamSnapshot.data != null
                                      ? streamSnapshot.data?.docs.length
                                      : 0,
                                  itemBuilder: (ctx, index) =>
                                      Container(

                                          child: (streamSnapshot.data != null &&
                                              streamSnapshot.data?.docs[index]
                                                  .id ==
                                                  widget.post_item.user_id) ?
                                          CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  streamSnapshot.data
                                                      ?.docs[index]['image_path'] ??
                                                      " "),
                                              radius: 25.0) :
                                          Container()
                                      )
                              );
                            },
                          ),

                        ),
                      ]),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(30.0, 6.0, 20.0, 0.0),
                    child:
                    Container(
                        child: (widget.post_item.image_link != "") ?
                        Image(
                            image: NetworkImage(widget.post_item.image_link ??
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg")
                        ) :
                        Container()
                    )
                ),
                SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: (widget.post_item.caption != "") ?
                              Text(widget.post_item.caption ?? "") :
                              Container()
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              LikeButton(
                                  size: 25.0,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  likeCount: widget.post_item.like_id != null
                                      ? widget.post_item.like_id?.length
                                      : 0,
                                  onTap: LikeButtonTapped,
                                  isLiked: Liked()
                              ),
                              IconButton(
                                  iconSize: 23,
                                  color: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      showWidget = !showWidget;
                                    });
                                    print(showWidget);
                                  },
                                  icon: Icon(Icons.add_comment)),
                              Spacer(),
                              Column(

                                children: [
                                  Container(
                                      child: (widget.post_item.reshared_by ==
                                          userid) ?
                                      IconButton(
                                        iconSize: 23,
                                        onPressed: deletePost,
                                        icon: Icon(Icons.delete),
                                        color: Colors.grey,
                                      ) :
                                      Container()
                                  )
                                ],),

                              IconButton(
                                iconSize: 23,
                                onPressed: report,
                                icon: Icon(Icons.report),
                                color: Colors.grey,
                              ),


                            ],
                          ),
                        ],
                      )
                  ),
                ),
                showWidget ?
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('comments')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          return ListView.builder(
                            //physics: NeverScrollableScrollPhysics(),

                              clipBehavior: Clip.antiAlias,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10),
                              itemCount: streamSnapshot.data != null
                                  ? streamSnapshot.data?.docs.length
                                  : 0,
                              itemBuilder: (ctx, index) =>
                                  Container(
                                      child: (streamSnapshot.data != null &&
                                          streamSnapshot.data
                                              ?.docs[index]['post_id'] ==
                                              widget.post_item.post_id) ?
                                      Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(streamSnapshot.data
                                                      ?.docs[index]['username'],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold
                                                      )
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    DateFormat.yMMMd()
                                                        .format(
                                                        streamSnapshot.data
                                                            ?.docs[index]['date']
                                                            .toDate())
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontStyle: FontStyle
                                                            .italic,
                                                        color: Colors.black38
                                                    ),
                                                    textAlign: TextAlign
                                                        .justify,
                                                  )
                                                ],
                                              ),
                                              Container(width: 10),
                                              Container(
                                                child: Text(streamSnapshot.data
                                                    ?.docs[index]['comment'],
                                                    textAlign: TextAlign
                                                        .justify),
                                              ),
                                              SizedBox(height: 5,)
                                            ],
                                          )) :
                                      Container()
                                  )
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          width: 150.0,
                          height: 25.0,
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'New Comment',
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 50.0,
                          height: 25.0,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Icon(
                                Icons.add_comment, size: 20.0, color: Colors
                                .white),
                            onPressed: () {
                              addNewComment(nameController.text);
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ) :
                Container()
              ]
          ),
        ),
      );
    };
  }
}