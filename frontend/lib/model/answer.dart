import 'user.dart';

class Answer implements Comparable {
  final int id;
  final User author;
  final String bodyMarkdown;
  final int upvotes;

  Answer({this.id, this.author, this.bodyMarkdown, this.upvotes=0});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['pk'],
      author: User.fromJson(json['author']),
      bodyMarkdown: json['body'],
      upvotes: json['upvotes'],
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
