import 'package:brave_app/User/models/user_tools.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Accounts/screens/signup_screen.dart';
import 'package:brave_app/Accounts/screens/login_screen.dart';
import 'package:brave_app/Accounts/screens/account_edit_menu.dart';
import 'package:brave_app/Accounts/screens/password_screen.dart';
import 'package:brave_app/Accounts/screens/user_picture_screen.dart';
import 'package:brave_app/Accounts/screens/edit_profile_screen.dart';
import 'package:brave_app/Accounts/screens/edit_document_screen.dart';
import 'package:brave_app/Common/screens/about_screen.dart';
import 'package:brave_app/User/screens/profile_screen.dart';
import 'package:brave_app/User/screens/subscription_status_screen.dart';
import 'package:brave_app/User/screens/users_search.dart';
import 'package:brave_app/User/screens/inbody_screen.dart';
import 'package:brave_app/Post/screens/posts_feed_screen.dart';
import 'package:brave_app/Post/screens/admin_info_posts_screen.dart';
import 'package:brave_app/Calendar/screens/reservation_screen.dart';
import 'package:brave_app/Calendar/screens/reservate_appointment_screen.dart';
import 'package:brave_app/Calendar/screens/calendar_screen.dart';
import 'package:brave_app/Calendar/screens/event_screen.dart';
import 'package:brave_app/Calendar/screens/health_survey_screen.dart';
import 'package:brave_app/Follow/screens/followers_screen.dart';
import 'package:brave_app/Product/screens/restaurant_screen.dart';
import 'package:brave_app/Product/screens/restaurant_product_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final String _userId = UserSimplePreferences.getUserId();

  // String de la ruta inicial de la MyApp, depende de si hay sesión iniciada:
  // es decir datos de usuario en shared preferences
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
    getUserKey();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brave',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        primaryColor: Color(0xff458F2E),
        fontFamily: 'Rubik',
      ),
      initialRoute: _initialRoute(),
      routes: {
        "/login": (BuildContext context) => LoginScreen(),
        "/signup": (BuildContext context) => SignUpScreen(),
        "/password": (BuildContext context) => PasswordScreen(),
        "/about": (BuildContext context) => AboutScreen(),
        "/account_edit_menu": (BuildContext context) => AccountEditMenu(),
        "/user_picture": (BuildContext context) => UserPictureScreen(),
        "/users_search": (BuildContext context) => UsersSearch(),
        "/inbody": (BuildContext context) => InbodyScreen(),
        "/profile": (BuildContext context) => ProfileScreen(),
        "/edit_profile": (BuildContext context) => EditProfileScreen(),
        "/edit_document": (BuildContext context) => EditDocumentScreen(),
        "/subscription_status": (BuildContext context) =>
            SubscriptionStatusScreen(),
        "/posts_feed_screen": (BuildContext context) => PostsFeedScreen(),
        "/admin_info_posts_screen": (BuildContext context) =>
            AdminInfoPostsScreen(),
        "/calendar_screen": (BuildContext context) => CalendarScreen(),
        "/event_screen": (BuildContext context) => EventScreen('5'),
        "/health_survey_screen": (BuildContext context) => HealthSurveyScreen(),
        "/reservation_screen": (BuildContext context) => ReservationScreen(),
        "/reservate_appointment": (BuildContext context) =>
            ReservateAppointmentScreen(),
        "/follow_followers": (BuildContext context) => FollowersScreen(),
        "/restaurant_screen": (BuildContext context) => RestaurantScreen(),
        "/restaurant_product_screen": (BuildContext context) =>
            RestaurantProductScreen(),
      },
    );
  }

  /* Cargar datos de usuario de SharedPreferences */
  void getUserKey() async {
    print('Cargando userkey:');
    Future _futureUserKey = UserTools().getUserKey(_userId);

    _futureUserKey.then((mapResponse) {
      print('userkey:' + mapResponse['userkey']);
      UserSimplePreferences.setUserKey(mapResponse['userkey']);
      UserSimplePreferences.setUserIK(_userId, mapResponse['userkey']);
    });
  }
}
