import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  //const ProfileScreen({Key key}) : super(key: key);

  final TextStyle _counterStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lina López')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: _profileInfo(context),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: ElevatedButton(
              onPressed: () => {_goToProfileEdit(context)},
              child: Text(
                'Editar perfil',
                style: TextStyle(color: Colors.black87),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
          Flexible(
            child: _postsGrid,
          ),
        ],
      ),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(),
    );
  }

  void _goToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, '/profile_edit');
  }

  Widget _profileInfo(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/img/lina.jpg'),
              radius: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Lina López'),
          ],
        ),
        InkWell(
          onTap: () {
            print('abriendo publicacioens');
          },
          child: Column(
            children: [
              Text('5', style: _counterStyle),
              Text('Publicaci...'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/follow_followers');
          },
          child: Column(
            children: [
              Text('18', style: _counterStyle),
              Text('Seguidor...'),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/follow_followers');
          },
          child: Column(
            children: [
              Text('135', style: _counterStyle),
              Text('Seguidos'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _postsGrid = GridView.count(
    crossAxisSpacing: 2,
    mainAxisSpacing: 2,
    crossAxisCount: 3,
    children: <Widget>[
      Container(
        child: Image.asset('assets/examples/sm_post_01.png'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_02.png'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_03.jpg'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_04.jpg'),
      ),
      Container(
        child: Image.asset('assets/examples/sm_post_05.png'),
      ),
    ],
  );
}
