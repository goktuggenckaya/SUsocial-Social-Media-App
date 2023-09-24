import 'package:cs310group1/services/post_database.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/FeedView/posts_list.dart';
import 'package:cs310group1/views/FeedView/selected_post_list.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/searchExplore/user_object.dart';
import 'package:cs310group1/views/searchExplore/users_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/services/user_database.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = "/searchExplore";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const ExploreScreen({Key? key, required this.analytics, required this.observer}) : super(key: key);


  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  AuthService auth = AuthService();

  late bool isShowingUser;

  @override
  void initState() {
    super.initState();
    isShowingUser = true;
  }

  String selectedCategory = '';

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context){
    if(SearchAppBar.query == '') {
      return StreamProvider<List<Post>?>.value(
        catchError: (BuildContext context, e) {
          print("Error: $e");
          return;
        }, // VIDEODA YOK EKLE
        value: PostsData().posts,
        initialData: null,
        child: Scaffold(
            backgroundColor: const Color(0xdbcdb9),
            body: SelectedPostList(),
            appBar: SearchAppBar(key: widget.key, height: 120)
        ),
      );
    }
    else {
      return StreamProvider<List<Users>?>.value(
        catchError:(BuildContext context, e) { print("Error: $e"); return ; }, // VIDEODA YOK EKLE
        value: UsersData(uid).users,
        initialData: null,
        child: Scaffold(
            backgroundColor: const Color(0xdbcdb9),
            body: UsersList(query: SearchAppBar.query, analytics: widget.analytics, observer: widget.observer),
            appBar: SearchAppBar(key: widget.key, height: 120)
        ),
      );
    }
  }

  Widget SelectedPostList() {
    if(SearchAppBar.selectedCategory == '') {
      return PostsList(analytics: widget.analytics, observer: widget.observer);
    }
    else {
      return SelectedPostsList(key: widget.key,
          query: SearchAppBar.selectedCategory,
          analytics: widget.analytics,
          observer: widget.observer);
    }
  }
}