import 'package:flutter/material.dart';
import 'package:frontend/views/post_content_view.dart';

import '../model/post.dart';

import 'package:dartz/dartz.dart' show Left, Right;

class PostView extends StatefulWidget {
  PostView(this.post, this.hasNavBar);
  final Post post;
  final bool hasNavBar;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.hasNavBar ? AppBar(title: Text('Question ' + widget.post.id.toString())) : null,
        body: createContent(context));
  }

  Widget createContent(BuildContext context) {
    return ListView.builder(
      itemCount: 1 + widget.post.answers.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return PostContentView(Left(widget.post));
        } else {
          return PostContentView(Right(widget.post.answers[index - 1]));
        }
      },
    );
  }
}
