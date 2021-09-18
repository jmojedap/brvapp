//import 'package:brave_app/src/screens/start_screen.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Accounts/screens/signup_screen.dart';
import 'package:brave_app/Accounts/screens/login_screen.dart';
import 'package:brave_app/Accounts/screens/password_screen.dart';
import 'package:brave_app/Accounts/screens/user_picture_screen.dart';
import 'package:brave_app/User/screens/profile_screen.dart';
import 'package:brave_app/User/screens/profile_edit_screen.dart';
import 'package:brave_app/User/screens/subscription_status_screen.dart';
import 'package:brave_app/User/screens/users_search.dart';
import 'package:brave_app/User/screens/performance_screen.dart';
import 'package:brave_app/Post/screens/posts_feed_screen.dart';
import 'package:brave_app/Post/screens/admin_info_posts_screen.dart';
import 'package:brave_app/Calendar/screens/reservation_screen.dart';
import 'package:brave_app/Calendar/screens/calendar_screen.dart';
import 'package:brave_app/Calendar/screens/event_screen.dart';
import 'package:brave_app/Calendar/screens/health_survey_screen.dart';
import 'package:brave_app/Follow/screens/followers_screen.dart';
import 'package:brave_app/Product/screens/restaurant_screen.dart';
import 'package:brave_app/Product/screens/restaurant_product_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final String _userId = UserSimplePreferences.getUserId();

  // String de la ruta inicial de la MyApp, dependidndo de si hay sesión iniciada
  // en shared preferences
  String _initialRoute() {
    if (_userId == '0') {
      return '/login';
    } else {
      return '/admin_info_posts_screen';
    }
  }

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brave',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        primaryColor: Color(0xff458F2E),
        fontFamily: 'Rubik',
      ),
      //initialRoute: '/start',
      initialRoute: _initialRoute(),
      routes: {
        "/login": (BuildContext context) => LoginScreen(),
        "/signup": (BuildContext context) => SignUpScreen(),
        "/password": (BuildContext context) => PasswordScreen(),
        "/user_picture": (BuildContext context) => UserPictureScreen(),
        "/users_search": (BuildContext context) => UsersSearch(),
        "/performance": (BuildContext context) => PerformanceScreen(),
        "/profile": (BuildContext context) => ProfileScreen(),
        "/profile_edit": (BuildContext context) => ProfileEditScreen(),
        "/subscription_status": (BuildContext context) =>
            SubscriptionStatusScreen(),
        "/posts_feed_screen": (BuildContext context) => PostsFeedScreen(),
        "/admin_info_posts_screen": (BuildContext context) =>
            AdminInfoPostsScreen(),
        "/calendar_screen": (BuildContext context) => CalendarScreen(),
        "/event_screen": (BuildContext context) => EventScreen('5'),
        "/health_survey_screen": (BuildContext context) => HealthSurveyScreen(),
        "/reservation_screen": (BuildContext context) => ReservationScreen(),
        "/follow_followers": (BuildContext context) => FollowersScreen(),
        "/restaurant_screen": (BuildContext context) => RestaurantScreen(),
        "/restaurant_product_screen": (BuildContext context) =>
            RestaurantProductScreen(),
      },
    );
  }
}
