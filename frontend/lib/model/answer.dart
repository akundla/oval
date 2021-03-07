import 'user.dart';

class Answer implements Comparable {
  final int id;
  final User author;
  final String bodyMarkdown;
  bool upvoted;
  int upvotes;

  Answer({this.id, this.author, this.bodyMarkdown, this.upvoted, this.upvotes});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['pk'],
      author: User.fromJson(json['author_info']),
      bodyMarkdown: json['body'],
      upvoted: json['user_upvoted'],
      upvotes: json['upvote_count'],
    );
  }

  @override
  int compareTo(other) {
    if (this.author.isInstructor == other.author.isInstructor) {
      return -1 * this.upvotes.compareTo(other.upvotes);
    } else {
      if (this.author.isInstructor) return -1;
      else return 1;
    }
  }
}
