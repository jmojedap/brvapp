import 'package:brave_app/Product/models/product_model.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

class RestaurantScreen extends StatefulWidget {
  //RestaurantScreen({Key? key}) : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  Future<List> futureProducts;

  /*final List<Color> _avatarColors = [
    Colors.red[700],
    Colors.purple[700],
    Colors.blue[700],
    Colors.yellow[700],
    Colors.orange[700],
    Colors.green[700],
  ];*/

  @override
  void initState() {
    super.initState();
    futureProducts = _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurante'),
      ),
      drawer: DrawerComponent(),
      body: _productsListView(),
      /*body: Text(
          'Hola a todos este es un texto largo para verificar si se pueden generar varios saltos de línea fuera de row o column'),*/
      bottomNavigationBar: BottomBarComponent(),
    );
  }

// SEGUIDORES
//--------------------------------------------------------------------------

  //Función de solicitud de JSON productos
  Future<List<Product>> _getProducts() async {
    const String urlProducts =
        'https://www.bravebackend.com/api/products/get/?cat_1=5010';
    final response = await http.get(Uri.parse(urlProducts));

    List<Product> objProducts = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['list']) {
        objProducts.add(Product.fromJson(item));
      }

      return objProducts;
    } else {
      throw Exception('Error al solicitar listado de productos');
    }
  }

  //ListView de productos
  Widget _productsListView() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: FutureBuilder(
        future: futureProducts,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _productsList(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // Por defecto devolver indicador de proceso de carga
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  //Lista con Widgets de productos
  List<Widget> _productsList(data) {
    List<Widget> products = [];

    for (var item in data) {
      products.add(_product(item));
    }

    return products;
  }

  // Widget producto
  //--------------------------------------------------------------------------
  Widget _product(item) {
    //Precio con formato
    var priceFormat = NumberFormat.currency(
      locale: 'es_CO',
      decimalDigits: 0,
      symbol: '',
    ).format(item.price.toInt());

    //Info producto
    var productInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          item.name,
          style: TextStyle(
            fontSize: 21,
            color: Colors.green[700],
          ),
        ),
        Container(
          width: 240,
          margin: EdgeInsets.only(top: 6, bottom: 6),
          child: Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black45, fontSize: 15),
          ),
        ),
        Text('\$ ' + priceFormat,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
      ],
    );

    //Widget producto
    var productThumbnail = Container(
      width: 80,
      height: 80,
      child: Image.network(
        item.urlThumbnail,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.redAccent,
      ),
    );

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/restaurant_product_screen',
            arguments: {'productId': 9});
      },
      child: Container(
        padding: const EdgeInsets.all(9.0),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black12,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            productInfo,
            productThumbnail,
          ],
        ),
      ),
    );
  }
}
