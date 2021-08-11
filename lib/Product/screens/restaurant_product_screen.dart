import 'package:flutter/material.dart';

class RestaurantProductScreen extends StatefulWidget {
  RestaurantProductScreen({this.productId});

  final int productId;

  @override
  _RestaurantProductScreenState createState() =>
      _RestaurantProductScreenState();
}

class _RestaurantProductScreenState extends State<RestaurantProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desayuno D'),
      ),
      body: Column(
        children: [
          Image.network(
              'https://www.bravebackend.com/content/uploads/2021/07/200002_20210706065308_62.jpg'),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            margin: EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Desayuno D', style: TextStyle(fontSize: 36)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              '"Has maiorum habemus detraxit at. Timeam fabulas splendide et his. Facilisi aliquando sea ad, vel ne consetetur adversarium. Integre admodum et his, nominavi urbanitas et per, alii reprehendunt et qui. His ei meis legere nostro, eu kasd fabellas definiebas mei, in sea augue iriure.',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\$12.500',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'Agregar',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          print('Agregando producto');
        },
        backgroundColor: Colors.purple,
      ),
    );
  }
}
