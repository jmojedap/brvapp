import 'package:flutter/material.dart';

class BottomBarComponent extends StatefulWidget {
  //BottomBarComponent({Key? key}) : super(key: key);
  /*int indexTap;

  BottomBarComponent(this.indexTap);*/
  final int indexTap;
  BottomBarComponent(this.indexTap);

  @override
  _BottomBarComponentState createState() => _BottomBarComponentState();
}

class _BottomBarComponentState extends State<BottomBarComponent> {
  //int indexTap = 1;

  final List<String> routes = [
    '/admin_info_posts_screen',
    '/calendar_screen',
    '/profile',
  ];

  void onTapTapped(int index) {
    setState(() {
      //indexTap = index;
      //String newScreen = routes
      //print('Index: $index');
      print('Index:' + routes[index]);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routes[index], (route) => false);
      //Navigator.of(context).restorablePushNamed(routes[indexTap]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTapTapped,
      currentIndex: widget.indexTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
