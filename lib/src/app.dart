import 'package:brave_app/src/screens/general_search_screen.dart';
import 'package:brave_app/src/screens/login_screen.dart';
import 'package:brave_app/src/screens/start_screen.dart';
import 'package:brave_app/src/screens/signup_screen.dart';
import 'package:brave_app/User/screens/profile_screen.dart';
import 'package:brave_app/User/screens/profile_edit_screen.dart';
import 'package:brave_app/User/screens/subscription_status_screen.dart';
import 'package:brave_app/Post/screens/posts_feed_screen.dart';
import 'package:brave_app/Events/screens/reservation_screen.dart';
import 'package:brave_app/Events/screens/calendar_screen.dart';
import 'package:brave_app/Follow/screens/followers_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        primaryColor: Colors.green,
        accentColor: Colors.green[800],
      ),
      initialRoute: '/profile',
      routes: {
        "/start": (BuildContext context) => StartScreen(),
        "/login": (BuildContext context) => LoginScreen(),
        "/signup": (BuildContext context) => SignUpScreen(),
        "/general_search": (BuildContext context) => GeneralSearchScreen(),
        "/profile": (BuildContext context) => ProfileScreen(),
        "/profile_edit": (BuildContext context) => ProfileEditScreen(),
        "/subscription_status": (BuildContext context) =>
            SubscriptionStatusScreen(),
        "/posts_feed_screen": (BuildContext context) => PostsFeedScreen(),
        "/reservation_screen": (BuildContext context) => ReservationScreen(),
        "/calendar_screen": (BuildContext context) => CalendarScreen(),
        "/follow_followers": (BuildContext context) => FollowersScreen(),
      },
    );
  }
}
