import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InbodyScreen extends StatefulWidget {
//InbodyScreen({Key? key}) : super(key: key);

  @override
  InbodyScreenState createState() => InbodyScreenState();
}

class InbodyScreenState extends State<InbodyScreen> {
  bool hasInternet = false;
  String connectionStatus = 'Cargando...';
  String appendAuth = UserSimplePreferences.getAppendAuth();

  bool loadingPage = true;
  String url = 'https://www.bravebackend.com/app/inbody/user_report?';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  //connectivityResult = await Connectivity().checkConnectivity();

  @override
  void initState() {
    super.initState();

    checkConnection();
  }

  Future checkConnection() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: titleContent()),
        body: Stack(
          children: [
            webViewContent(),
            loadingPageIndicator(),
          ],
        ),
      ),
    );
  }

  /// Contenido del Scaffold AppBar
  /// 2021-11-16
  Widget titleContent() {
    if (loadingPage) {
      return Row(
        children: [
          SizedBox(
            child: CircularProgressIndicator(color: Colors.white),
            height: 25,
            width: 25,
          ),
          SizedBox(width: 20),
          Text('Mediciones InBody'),
        ],
      );
    } else {
      return Text('Mediciones InBody');
    }
  }

  Widget loadingPageIndicator() {
    if (loadingPage == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
  }

  Widget webViewContent() {
    if (hasInternet) {
      return WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url + appendAuth,
        onPageFinished: (String url) {
          print('Page finished loadingPage: $url');
          setState(() {
            loadingPage = false;
          });
        },
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      );
    } else {
      connectionStatus = 'Sin conexión';
      loadingPage = false;
      return Center(
        child: Text(connectionStatus),
      );
    }
  }
}
