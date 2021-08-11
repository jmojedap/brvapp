import 'package:flutter/material.dart';
import 'package:brave_app/src/app.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(MyApp());
}
