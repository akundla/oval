import 'user.dart';

class Post {
  final int id;
  final String title;
  final User author;
  final String bodyMarkdown;

  Post({this.id, this.title, this.author, this.bodyMarkdown});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      author: User.fromJson(json['author']),
      bodyMarkdown: json['bodyMarkdown'],
    );
  }
}
