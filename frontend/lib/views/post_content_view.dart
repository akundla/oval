import 'package:flutter/material.dart';

import '../model/post.dart';
import '../model/answer.dart';

import 'package:dartz/dartz.dart';

class PostContentView extends StatelessWidget {
  PostContentView(this.content);
  final Either<Post, Answer> content;

  @override
  Widget build(BuildContext context) {
    Widget retVal;
    content.fold(
        (post) => {
              retVal = Card(
                  child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.bodyMarkdown)))
            },
        (answer) => {
              retVal = Card(
                  child: ListTile(
                      title: Text(answerTitle(answer)),
                      subtitle: Text(answer.bodyMarkdown)))
            });
    return retVal;
  }

  static String answerTitle(Answer answer) {
    var author = answer.author;
    var title = author.firstName + ' ' + author.lastName + "'s Answer";
    if (author.isInstructor) {
      title += ' (instructor) ';
    } else {
      title += ' (student) ';
    }
    return title + answer.upvotes.toString() + ' upvotes';
  }
}
