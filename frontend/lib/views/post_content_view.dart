import 'package:flutter/material.dart';

import '../model/post.dart';
import '../model/answer.dart';

import 'package:dartz/dartz.dart';

final double UPVOTE_BUTTON_WIDTH = 125;

typedef UpvoteFunc = void Function(dynamic p);

class PostContentView extends StatelessWidget {
  PostContentView(this.content, this.upvote);
  final Either<Post, Answer> content;
  final UpvoteFunc upvote;

  @override
  Widget build(BuildContext context) {
    Widget retVal;
    content.fold(
        (post) => {
              retVal = Card(
                  child: Column(children: [
                ListTile(
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
                    subtitle: Text(post.bodyMarkdown),
                    trailing: Container(
                        width: UPVOTE_BUTTON_WIDTH, child: upvoteButton(post)))
              ]))
            },
        (answer) => {
              retVal = Card(
                  child: Column(
                children: [
                  ListTile(
                      leading: Icon(Icons.star_outline,
                          color: Colors.black,
                          size: 32,
                          semanticLabel: 'Answer'),
                      title: Text(answer.author.firstName +
                          ' ' +
                          answer.author.lastName +
                          "'s Answer"),
                      subtitle: Text(answer.bodyMarkdown),
                      trailing: Container(
                          width: UPVOTE_BUTTON_WIDTH,
                          child: upvoteButton(answer)))
                ],
              ))
            });
    return retVal;
  }

  ElevatedButton upvoteButton(dynamic upvotable) {
    return ElevatedButton(
        onPressed: () {
          upvote(upvotable);
        },
        child: Row(
          children: [
            Icon(upvotable.upvoted ? Icons.arrow_downward : Icons.arrow_upward,
                color: Colors.white,
                size: 32,
                semanticLabel:
                    upvotable.upvoted ? 'Downward arrow' : 'Upward arrow'),
            Text(' ' + upvotable.upvotes.toString() + ' Upvotes')
          ],
        ));
  }
}
