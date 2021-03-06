class Post {
  final String title;
  final Author author;
  final String bodyMarkdown;

  Post({this.userId, this.id, this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
