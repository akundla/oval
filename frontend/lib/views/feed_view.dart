import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedView extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedView> {
  Future<List<Post>> posts;
  @override
  void initState() {
    super.initState();
    posts = self.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<http.Response> fetchAlbum() {
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
