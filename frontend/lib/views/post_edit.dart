import 'package:flutter/material.dart';
import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/post.dart';
import '../singletons/auth_token.dart';

// Stolen from https://github.com/ahmed-alzahrani/Flutter_Simple_Login/blob/master/lib/main.dart
class PostEditView extends StatefulWidget {
  PostEditView(this.post);
  final Post post;

  @override
  State<StatefulWidget> createState() => new _PostEditViewState(post);
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _PostEditViewState extends State<PostEditView> {
  TextEditingController questionTitleController;
  TextEditingController questionBodyController;

  String questionTitle = "";
  String questionBody = "";
  bool loading = false;
  String error = null;

  _PostEditViewState(Post post) {
    if (post != null) {
      questionTitleController = new TextEditingController(text: post.title);
      questionBodyController =
          new TextEditingController(text: post.bodyMarkdown);
    } else {
      questionTitleController = new TextEditingController();
      questionBodyController = new TextEditingController();
    }
    questionTitleController.addListener(questionTitleListen);
    questionBodyController.addListener(questionBodyListen);
  }

  void questionTitleListen() {
    if (questionTitleController.text.isEmpty) {
      questionTitle = "";
    } else {
      questionTitle = questionTitleController.text;
    }
  }

  void questionBodyListen() {
    if (questionBodyController.text.isEmpty) {
      questionBody = "";
    } else {
      questionBody = questionBodyController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: new ListView(
      children: [
        new Container(
          child: new TextField(
            controller: questionTitleController,
            decoration: new InputDecoration(labelText: 'Title'),
          ),
        ),
        new Container(
          child: new TextField(
            controller: questionBodyController,
            decoration: new InputDecoration(labelText: 'Question Body'),
          ),
        ),
        new TextButton(
          child: Text("Submit"),
          onPressed: submit,
        )
      ],
    ));
  }

  void submit() async {
    if (loading) return;
    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.http(env['API_HOST'], '/posts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token " + authToken.value,
      },
      body: jsonEncode(
          <String, String>{'title': questionTitle, 'body': questionBody}),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> rJSON = jsonDecode(response.body);
      if (rJSON.containsKey('pk')) {
        // We have pk, bye
        Navigator.pop(context, Post.fromJson(rJSON));
      }
      setState(() {
        loading = false;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        loading = false;
        error = "Invalid credentials.";
      });
    }
  }
}
