class Publicacion {
  final String title;
  final String urlImage;
  final String thumbnail;

  Publicacion({this.title, this.thumbnail, this.urlImage});

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      title: json['post_name'],
      urlImage: json['url_image'],
      thumbnail: json['url_thumbnail'],
    );
  }
}
