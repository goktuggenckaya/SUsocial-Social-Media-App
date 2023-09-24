import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/views/login/loginView.dart';
import 'package:cs310group1/views/Welcome_Page/welcome.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Walkthrough extends StatefulWidget {
  const Walkthrough({Key? key, required this.analytics, required this.observer}) : super(key: key);
  static const routeName = "/walkthrough";

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  PageController pc = PageController(initialPage: 0);

  Future setIsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isShown', true);
  }

  void buttonClicked() {
    Navigator.pushNamedAndRemoveUntil(context, WelcomePage.routeName, (Route<dynamic> route) => false);
    setIsShown();
    widget.analytics.setCurrentScreen(screenName: 'Welcome Page');
  }
  int currentpage=0;

  List<String> Categories = [
    "Sports",
    "Ride Sharing",
    "Study Buddy",
    "Movie Marathon",
    "Share a Meal",
    "Expand your circle",
    "Events"
  ];
  List<String> CategoryExplanations = [
    "So, you want a partner for a specific sports..",
    "Do you need a ride or need someone to ride with?",
    "Social facilitation studies show that people work better together. Let's find you one!",
    "Tired of courses? Arrange a movie marathon and invite others!",
    "Hungry? Go get some meal with friends",
    "United we stand, divided we fall",
    "It's time to go out, let's check what city holds for us?"
  ];
  List<String> ImageURLs = [
    "https://www.sabanciuniv.edu/sites/default/files/futbolsaha.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/SabanciUniversity_DormView.jpg/800px-SabanciUniversity_DormView.jpg",
    "https://www.sabanciuniv.edu/sites/default/files/bilgimerkezi_340x325_0.jpg",
    "https://d1bvpoagx8hqbg.cloudfront.net/originals/1b89a3401da378cf8ba7c44085eed880.jpg",
    "https://d1bvpoagx8hqbg.cloudfront.net/originals/b65e6ab94e648b999def3b2b337959e0.jpg",
    "https://iro.sabanciuniv.edu/sites/iro.sabanciuniv.edu/files/9255648182_1d82fcf98c_z.jpg",
    "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iihRXMchUj2U/v1/-1x-1.jpg"
  ];

  void _onPageChanged (int currentpage) {
    // ignore: avoid_print
    print("Current page: " + Categories[currentpage]);
    if(currentpage <= 6) {
      widget.analytics.setCurrentScreen(screenName: Categories[currentpage]);
    }
    else {
      widget.analytics.setCurrentScreen(screenName: 'End of Walktrough');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.W_Background, //to be determined later
        appBar:AppBar(
          backgroundColor: AppColors.W_appBarBackground, //to be determined later
          title: Text(
            "CS310 Social Media Project",
            style: W_appBarText, //to be determined later
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: PageView(
            controller: pc,
            onPageChanged: _onPageChanged,
            children: [
              Scaffold(
                backgroundColor: AppColors.W_Background,
                body: SafeArea(
                  child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              Categories[currentpage],
                              style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.topCenter,
                                image: NetworkImage(ImageURLs[currentpage]),
                              )
                            ),
                            height:280
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              CategoryExplanations[currentpage],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                            ),
                          ),
                        ),
                      ],
                    )
                )
              ),
              Scaffold(
                  backgroundColor: AppColors.W_Background,
                  body: SafeArea(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                Categories[1],
                                style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(ImageURLs[1]),
                                    )
                                ),
                                height:280
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                CategoryExplanations[1],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              ),
              Scaffold(
                  backgroundColor: AppColors.W_Background,
                  body: SafeArea(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                Categories[2],
                                style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(ImageURLs[2]),
                                    )
                                ),
                                height:280
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                CategoryExplanations[2],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              ),
              Scaffold(
                  backgroundColor: AppColors.W_Background,
                  body: SafeArea(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                Categories[3],
                                style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(ImageURLs[3]),
                                    )
                                ),
                                height:280
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                CategoryExplanations[3],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              ),
              Scaffold(
                  backgroundColor: AppColors.W_Background,
                  body: SafeArea(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                Categories[4],
                                style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(ImageURLs[4]),
                                    )
                                ),
                                height:280
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                CategoryExplanations[4],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              ),
              Scaffold(
                  backgroundColor: AppColors.W_Background,
                  body: SafeArea(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                Categories[5],
                                style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(ImageURLs[5]),
                                    )
                                ),
                                height:280
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                CategoryExplanations[5],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              ),
              Scaffold(
                  backgroundColor: AppColors.W_Background,
                  body: SafeArea(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                Categories[6],
                                style:  GoogleFonts.dosis(textStyle: W_categoriesStyle), //to be determined later
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(ImageURLs[6]),
                                    )
                                ),
                                height:280
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                CategoryExplanations[6],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(textStyle:W_categoryExplStyle) , //to be determined later
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Container(
                    child:
                    FloatingActionButton(onPressed: buttonClicked,
                      backgroundColor: Colors.orange, //to be determined later
                      child:
                        Text("LET'S START",
                          style: kHeadingTextStyle, //to be determined later
                        ),
                    )
                ),
              ),
            ],
          ),

        ),

    );
  }
}