import 'package:flutter/material.dart';
import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/post.dart';
import '../model/answer.dart';

import '../singletons/auth_token.dart';

// Stolen from https://github.com/ahmed-alzahrani/Flutter_Simple_Login/blob/master/lib/main.dart
typedef NewAnswerCallback = void Function(Answer a);

class NewAnswerView extends StatefulWidget {
  NewAnswerView(this.post, this.answer, this.answerCallback);
  final Post post;
  final Answer answer;
  final NewAnswerCallback answerCallback;

  @override
  State<StatefulWidget> createState() => new _NewAnswerViewState(post, answer);
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _NewAnswerViewState extends State<NewAnswerView> {
  TextEditingController questionBodyController;

  String questionBody = "";
  bool loading = false;
  String error = null;

  _NewAnswerViewState(Post post, Answer answer) {
    if (answer != null) {
      questionBodyController =
          new TextEditingController(text: answer.bodyMarkdown);
    } else {
      questionBodyController = new TextEditingController();
    }
    questionBodyController.addListener(questionBodyListen);
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
        child: new Column(
      children: [
        new Container(
          child: new TextField(
            controller: questionBodyController,
            decoration: new InputDecoration(labelText: 'Your Answer'),
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
      Uri.http(env['API_HOST'], '/posts/${widget.post.id.toString()}/answer/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token " + authToken.value,
      },
      body: jsonEncode(<String, String>{'body': questionBody}),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> rJSON = jsonDecode(response.body);
      if (rJSON.containsKey('pk')) {
        // We have pk, bye
        widget.answerCallback(Answer.fromJson(rJSON));
      }
      setState(() {
        loading = false;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        loading = false;
        error = "Error saving answer.";
      });
    }
  }
}
