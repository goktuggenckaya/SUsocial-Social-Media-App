import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/views/FeedView/feed_view.dart';
import 'package:cs310group1/addPost/add_image.dart';
import 'package:cs310group1/views/Notification_View/Notification_View.dart';
import 'package:cs310group1/views/Profile/profile.dart';
import 'package:cs310group1/views/searchExplore/explore_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/views/FeedView.dart';

class FeedView extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const FeedView({
    Key? key,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  AuthService auth = AuthService();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.W_appBarBackground,
          leading: IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ),
        body: const Center(
          child: Text(
            'FEED VIEW',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.W_appBarBackground,
            ),
          ),
        ),
      );
      //Show welcome screen
    }
    else {
      //return FeedView();
      //old return value
      var pages = [
        FeedPage(analytics: widget.analytics,observer:widget.observer),
        ExploreScreen(analytics: widget.analytics,observer:widget.observer),
        AddImage(analytics: widget.analytics,observer:widget.observer),
        NotificationView(),
        ProfilePage(analytics: widget.analytics, observer: widget.observer)
      ];
      return Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          backgroundColor: AppColors.W_appBarBackground,
          selectedItemColor: AppColors.navBarSelectedColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.home,
              color:AppColors.navBarSelectedColor ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,color:AppColors.navBarSelectedColor ),
                label: 'Explore'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_a_photo,color:AppColors.navBarSelectedColor ),
                label: 'Add'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications,color:AppColors.navBarSelectedColor ),
                label: 'Notifications'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,color:AppColors.navBarSelectedColor ),
              label: 'Profile',
            )
          ],
        ),
      );
    }
  }
}


