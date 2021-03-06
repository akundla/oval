import 'user.dart';

class Answer {
  final int id;
  final User author;
  final String bodyMarkdown;

  Answer({this.id, this.author, this.bodyMarkdown});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      author: User.fromJson(json['author']),
      bodyMarkdown: json['bodyMarkdown'],
    );
  }
}
