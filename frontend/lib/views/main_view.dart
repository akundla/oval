import 'package:flutter/material.dart';
import 'package:frontend/singletons/auth_token.dart';
import 'package:frontend/views/feed_view.dart';
import 'package:frontend/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    if (preferences == null) preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('token')) {
      setState(() {
        authToken.value = preferences.getString('token');
      });
    }
  }

  void setToken(token) async {
    await preferences.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    return authToken.value != null
        ? FeedView()
        : LoginPage((token) {
            setState(() {
              authToken.value = token;
            });
            setToken(authToken.value);
          });
  }
}
