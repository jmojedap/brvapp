import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brave_app/app.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

Future main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await UserSimplePreferences.init();
  runApp(MyApp());
}
