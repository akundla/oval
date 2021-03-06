import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';

class FeedView extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedView> {
  Future<List<Post>> posts;
  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.https(env['API_HOST'], 'posts'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable posts = jsonDecode(response.body);
      return List<Post>.from(posts.map((post) => Post.fromJson(post)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }
}
