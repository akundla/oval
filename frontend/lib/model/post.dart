import 'answer.dart';
import 'user.dart';

class Post {
  final int id;
  String title;
  final User author;
  String bodyMarkdown;
  final DateTime created;
  final bool answerable;
  bool unread;
  bool upvoted;
  int upvotes;
  List<Answer> answers;

  Post(
      {this.id,
      this.title,
      this.author,
      this.bodyMarkdown,
      this.created,
      this.answerable,
      this.unread,
      this.upvoted,
      this.upvotes,
      List<Answer> answers = null}) {
    this.answers = answers == null ? [] : answers;
    this.answers.sort();
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['pk'],
      title: json['title'],
      author: User.fromJson(json['author']),
      bodyMarkdown: json['body'],
      created: DateTime.parse(json['created_date']),
      answerable: json['answerable'],
      unread: !json['user_viewed'],
      upvoted: json['user_upvoted'],
      upvotes: json['upvote_count'],
      answers: getAnswers(json['answers_post'])
    );
  }

  static List<Answer> getAnswers(answers) {
    return List<Answer>.from(answers.map((answer) => Answer.fromJson(answer)));
  }
}
