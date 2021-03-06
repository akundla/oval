import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../model/user.dart';
import 'post_view.dart';

class FeedView extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedView> {
  Future<List<Post>> posts;
  Post currentlyViewing;
  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
    currentlyViewing = null;
  }

  Widget buildFromPosts(BuildContext context, List<Post> posts) {
    final lvb = ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
                title: Text('${posts[index].title}'),
                subtitle: Text('${posts[index].bodyMarkdown}', maxLines: 1),
                onTap: () {
                  currentlyViewing = posts[index];
                  if (MediaQuery.of(context).size.width > 600) {
                    setState(() {});
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new PostView(currentlyViewing, true)),
                    );
                  }
                }));
      },
    );
    return OrientationBuilder(builder: (context, orientation) {
      var isLargeScreen;
      if (MediaQuery.of(context).size.width > 600) {
        isLargeScreen = true;
      } else {
        isLargeScreen = false;
      }
      return Row(children: [
        Expanded(child: lvb),
        isLargeScreen
            ? Expanded(
                child: currentlyViewing != null
                    ? PostView(currentlyViewing, false)
                    : Container())
            : Container()
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildFromPosts(context, snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Post>> fetchPosts() async {
    var u = User(
        id: 0, firstName: "Andrew", lastName: "Haberlandt", email: "email");
    List<Post> dumber = [
      Post(
          author: u, id: 0, title: "big ddumb", bodyMarkdown: "yeeeee\n======"),
      Post(
          author: u,
          id: 0,
          title: "big ddumb2",
          bodyMarkdown: "yeeeee\n======"),
      Post(
          author: u, id: 0, title: "big ddumb3", bodyMarkdown: "yeeeee\n======")
    ];
    return dumber;
    final response = await http.get(Uri.https(env['API_HOST'], 'posts'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable posts = jsonDecode(response.body);
      List<Post> dumb =
          List<Post>.from(posts.map((post) => Post.fromJson(post)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }
}
