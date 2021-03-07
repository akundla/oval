import 'package:flutter/material.dart';
import 'package:frontend/views/post_content_view.dart';

import '../model/post.dart';
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
      itemCount: 1 + widget.post.answers.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return PostContentView(Left(widget.post), upvote);
        } else {
          return PostContentView(Right(widget.post.answers[index - 1]), upvote);
        }
      },
    );
  }

  void upvote(Post post) async {
    final response = await http.post(
      Uri.http(env['API_HOST'], 'posts/' + post.id.toString() + '/upvote/'),
      headers: {
        HttpHeaders.authorizationHeader: "Token " + authToken.value,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode(<String, String>{'state': true.toString()}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(jsonDecode(response.toString()).toString());
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to mark post viewed');
    }
  }
}
