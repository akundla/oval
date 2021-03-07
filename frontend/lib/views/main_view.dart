import 'package:flutter/material.dart';
import 'package:frontend/views/feed_view.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/post_content_view.dart';

import '../model/post.dart';

import 'package:dartz/dartz.dart' show Left, Right;

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String auth_token = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return auth_token != null
        ? FeedView()
        : LoginPage((token) {
            setState(() {
              auth_token = token;
            });
          });
  }
}
