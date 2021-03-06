import 'dart:convert';

import 'answer.dart';
import 'user.dart';

class Post {
  final int id;
  final String title;
  final User author;
  final String bodyMarkdown;
  List<Answer> answers;

  Post({this.id, this.title, this.author, this.bodyMarkdown, List<Answer> answers=null}) {
    this.answers = answers == null ? [] : answers;
    this.answers.sort();
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      author: User.fromJson(json['author']),
      bodyMarkdown: json['bodyMarkdown'],
      answers: getAnswers(json['answers'])
    );
  }

  static List<Answer> getAnswers(answersJson) {
    Iterable answers = jsonDecode(answersJson);
    return List<Answer>.from(answers.map((answer) => Answer.fromJson(answer)));
  }
}
