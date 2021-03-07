import 'package:flutter/material.dart';

import '../model/post.dart';
import '../model/answer.dart';

import 'package:dartz/dartz.dart';

typedef UpvoteFunc = void Function(Post p);

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
                  child: Column(children: [
                ListTile(
                    leading: Icon(Icons.star_outline,
                        color: Colors.black, size: 32, semanticLabel: 'Answer'),
                    title: Text(answerTitle(answer)),
                    subtitle: Text(answer.bodyMarkdown)),
                Container(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward_outlined,
                                color: Colors.black,
                                size: 32,
                                semanticLabel: 'Upvote'),
                            Text('Upvote')
                          ],
                        )))
              ]))
            });
    return retVal;
  }

  static String answerTitle(Answer answer) {
    return answer.author.firstName +
        ' ' +
        answer.author.lastName +
        "'s Answer has " +
        answer.upvotes.toString() +
        ' upvotes';
  }
}
