class Follower {
  final int userId;
  final String userName;
  final String displayName;
  final String urlThumbnail;

  Follower({this.userId, this.userName, this.displayName, this.urlThumbnail});

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      userId: int.parse(json['id']),
      userName: json['username'],
      displayName: json['display_name'],
      urlThumbnail: json['url_thumbnail'],
    );
  }
}
