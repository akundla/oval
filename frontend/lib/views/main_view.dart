import 'package:flutter/material.dart';
import 'package:frontend/views/feed_view.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/post_content_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/post.dart';

import 'package:dartz/dartz.dart' show Left, Right;

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String auth_token = null;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.setMockInitialValues(
        {"token": "8e9abf63c1eec6eaebdf1cbd7744bc262bf39ac9"});
    get_token();
  }

  void get_token() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      final new_token = prefs.getString('token');
      print("have token " + new_token.toString());
      setState(() {
        auth_token = new_token;
      });
    } else {
      print("No shared prefs " + prefs.getString('token').toString());
    }
  }

  void set_token(token) async {
    final succ = await prefs.setString('token', token);
    print("set token retval " + succ.toString());
  }

  @override
  Widget build(BuildContext context) {
    return auth_token != null
        ? FeedView()
        : LoginPage((token) {
            setState(() {
              auth_token = token;
              set_token(auth_token);
              print("token " + token.toString());
            });
          });
  }
}
