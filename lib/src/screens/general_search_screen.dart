import 'package:flutter/material.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';

class GeneralSearchScreen extends StatefulWidget {
  //GeneralSearchScreen({Key? key}) : super(key: key);

  @override
  _GeneralSearchScreenState createState() => _GeneralSearchScreenState();
}

class _GeneralSearchScreenState extends State<GeneralSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.all(12),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black38,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black38,
                  ),
                ),
                hintText: 'Buscar',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarComponent(),
    );
  }
}
