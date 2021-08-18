import 'package:flutter/material.dart';

class BottomBarComponent extends StatefulWidget {
  //BottomBarComponent({Key? key}) : super(key: key);
  /*int indexTap;

  BottomBarComponent(this.indexTap);*/

  @override
  _BottomBarComponentState createState() => _BottomBarComponentState();
}

class _BottomBarComponentState extends State<BottomBarComponent> {
  int indexTap = 0;

  final List<String> routes = [
    '/admin_info_posts_screen',
    '/calendar_screen',
    '/profile',
  ];

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
      //String newScreen = routes
      print('Index: $index');
      print('Index:' + routes[indexTap]);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routes[indexTap], (route) => false);
      //Navigator.of(context).restorablePushNamed(routes[indexTap]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTapTapped,
      currentIndex: indexTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text(''),
        ),
      ],
    );
  }
}
