import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brave_app/src/app.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await UserSimplePreferences.init();
  runApp(MyApp());
}
