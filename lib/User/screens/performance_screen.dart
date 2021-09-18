import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PerformanceScreen extends StatefulWidget {
//PerformanceScreen({Key? key}) : super(key: key);

  @override
  PperformanceScreenState createState() => PperformanceScreenState();
}

class PperformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Desempeño'),
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.bravebackend.com/app/accounts/login',
        ),
      ),
    );
  }
}
