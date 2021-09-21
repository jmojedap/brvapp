import 'package:brave_app/Config/constants.dart';
import 'package:brave_app/Post/models/posts_tools.dart';
import 'package:brave_app/Common/screens/bottom_bar_component.dart';
import 'package:brave_app/Common/screens/drawer_component.dart';
import 'package:flutter/material.dart';

class AdminInfoPostsScreen extends StatefulWidget {
  //AdminInfoPostsScreen({Key? key}) : super(key: key);

  @override
  _AdminInfoPostsScreenState createState() => _AdminInfoPostsScreenState();
}

class _AdminInfoPostsScreenState extends State<AdminInfoPostsScreen> {
  bool loading = false;
  String currentSection = 'loading_no';
  PostsTools postsTools = PostsTools();
  Future<List> futurePosts;
  List responsePosts = [
    {'title': '', 'content': '', 'url_image': kDefaultPostPicture}
  ];

  @override
  void initState() {
    super.initState();
    futurePosts = postsTools.getAdminInfoPosts();
    futurePosts.then((response) {
      responsePosts = response;
      loading = false;
      currentSection = 'postContent';
      setState(() {
        setBodyContent(currentSection);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Brave')),
        body: setBodyContent(currentSection),
        drawer: DrawerComponent(),
        bottomNavigationBar: BottomBarComponent(0),
      ),
    );
  }

  Widget setBodyContent(section) {
    if (section == 'loading') {
      return Center(child: CircularProgressIndicator());
    }
    return postContent();
  }

  Widget postContent() {
    return ListView.builder(
      itemCount: responsePosts.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage:
                          AssetImage('assets/img/logo-square-144.png'),
                      backgroundColor: Colors.white70,
                    ),
                    SizedBox(width: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Brave',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              postImage(responsePosts[index]),
              SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  responsePosts[index]['content'],
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/calendar_screen',
                    (route) => false,
                  );
                },
                child: Text('Continuar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget postImage(post) {
    if (post['url_image'].length > 0) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/img/loading.gif',
        image: post['url_image'],
      );
    }
    return SizedBox();
  }
}
