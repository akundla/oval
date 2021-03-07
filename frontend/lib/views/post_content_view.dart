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
                      leading: post.answerable
                          ? Icon(Icons.question_answer_outlined,
                              color: Colors.black,
                              size: 32,
                              semanticLabel: 'Question')
                          : Icon(Icons.note_outlined,
                              color: Colors.black,
                              size: 32,
                              semanticLabel: 'Note'),
                      title: Text(post.title),
                      subtitle: Text(post.bodyMarkdown)))
            },
        (answer) => {
              retVal = Card(
                  child: ListTile(
                      leading: Icon(Icons.star_outline,
                          color: Colors.black,
                          size: 32,
                          semanticLabel: 'Answer'),
                      title: Text(answerTitle(answer)),
                      subtitle: Text(answer.bodyMarkdown)))
            });
    return retVal;
  }

  static String answerTitle(Answer answer) {
    return answer.author.firstName + ' ' + answer.author.lastName + "'s Answer has " + answer.upvotes.toString() + ' upvotes';
  }
}
