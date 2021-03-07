import 'package:flutter/material.dart';
import 'package:frontend/views/post_content_view.dart';
import 'package:frontend/views/new_answer_view.dart';

import '../model/post.dart';
import '../model/answer.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:frontend/singletons/auth_token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        appBar: widget.hasNavBar
            ? AppBar(title: Text('Question ' + widget.post.id.toString()))
            : null,
        body: createContent(context));
  }

  Widget createContent(BuildContext context) {
    return ListView.builder(
      itemCount: 2 + widget.post.answers.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return PostContentView(Left(widget.post), upvote);
        } else if (index == 1 + widget.post.answers.length) {
          return NewAnswerView(widget.post, null, newAnswer);
        } else {
          return PostContentView(Right(widget.post.answers[index - 1]), upvote);
        }
      },
    );
  }

  void newAnswer(Answer a) {
    setState(() {
      widget.post.answers.add(a);
    });
  }

  void upvote(dynamic upvotable) async {
    final type = upvotable.runtimeType == Post ? 'posts' : 'answer';
    final response = await http.post(
      Uri.http(
          env['API_HOST'], '$type/' + upvotable.id.toString() + '/upvote/'),
      headers: {
        HttpHeaders.authorizationHeader: "Token " + authToken.value,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode(<String, dynamic>{'state': !upvotable.upvoted}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        upvotable.upvoted = jsonDecode(response.body)['upvoted'];
        upvotable.upvotes = jsonDecode(response.body)['upvotes'];
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to mark post viewed');
    }
  }
}
