import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/singletons/auth_token.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:frontend/model/post.dart';
import 'post_view.dart';

const MOBILE_BREAKPOINT = 768;

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
                subtitle: Text('${posts[index].bodyMarkdown}', maxLines: 3),
                trailing: Column(
                  children: [
                    Text(DateFormat.jm()
                        .format(posts[index].created)
                        .toString()),
                    SizedBox(height: 8),
                    posts[index].unread
                        ? Icon(Icons.circle,
                            color: Colors.blue,
                            size: 16,
                            semanticLabel: 'Unread')
                        : SizedBox.shrink(),
                  ],
                ),
                onTap: () {
                  currentlyViewing = posts[index];
                  if (MediaQuery.of(context).size.width > MOBILE_BREAKPOINT) {
                    setState(() {
                      if (currentlyViewing.unread) {
                        // TODO: mark post as read via API
                        currentlyViewing.unread = false;
                      }
                    });
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
    return LayoutBuilder(builder: (context, orientation) {
      var isLargeScreen;
      if (MediaQuery.of(context).size.width > MOBILE_BREAKPOINT) {
        isLargeScreen = true;
      } else {
        isLargeScreen = false;
      }
      return Row(children: [
        Expanded(flex: 3, child: lvb),
        isLargeScreen
            ? Expanded(
                flex: 7,
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
    final response = await http.get(
      Uri.http(env['API_HOST'], 'posts'),
      headers: {HttpHeaders.authorizationHeader: "Token " + authToken.value},
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable posts = jsonDecode(response.body)['results'];
      return List<Post>.from(posts.map((post) => Post.fromJson(post)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }
}
