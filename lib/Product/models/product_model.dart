class Product {
  final int productId;
  final String name;
  final String description;
  final double price;
  final String urlImage;
  final String urlThumbnail;

  Product({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.urlImage,
    this.urlThumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: int.parse(json['id']),
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      urlImage: json['url_image'],
      urlThumbnail: json['url_thumbnail'],
    );
  }
}
