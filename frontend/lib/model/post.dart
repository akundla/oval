import 'dart:convert';

import 'answer.dart';
import 'user.dart';

class Post {
  final int id;
  final String title;
  final User author;
  final String bodyMarkdown;
  final DateTime created;
  bool unread;
  List<Answer> answers;

  Post({this.id, this.title, this.author, this.bodyMarkdown, this.created, this.unread, List<Answer> answers=null}) {
    this.answers = answers == null ? [] : answers;
    this.answers.sort();
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      author: User.fromJson(json['author']),
      bodyMarkdown: json['bodyMarkdown'],
      created: DateTime.parse(json['created']),
      unread: json['unread'],
      answers: getAnswers(json['answers'])
    );
  }

  static List<Answer> getAnswers(answersJson) {
    Iterable answers = jsonDecode(answersJson);
    return List<Answer>.from(answers.map((answer) => Answer.fromJson(answer)));
  }
}
