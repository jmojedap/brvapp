class User {
  final int userId;
  final String userName;
  final String displayName;
  final String urlThumbnail;

  User({this.userId, this.userName, this.displayName, this.urlThumbnail});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: int.parse(json['id']),
      userName: json['username'],
      displayName: json['display_name'],
      urlThumbnail: json['url_thumbnail'],
    );
  }
}
