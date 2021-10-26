import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';

class InbodyScreen extends StatefulWidget {
//InbodyScreen({Key? key}) : super(key: key);

  @override
  InbodyScreenState createState() => InbodyScreenState();
}

class InbodyScreenState extends State<InbodyScreen> {
  String appendAuth = UserSimplePreferences.getAppendAuth();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Desempeño'),
        ),
        body: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'https://www.bravebackend.com/app/inbody/user_report?' +
                appendAuth),
      ),
    );
  }
}
