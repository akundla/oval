import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/answer.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';
import '../model/user.dart';
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
                subtitle: Text('${posts[index].bodyMarkdown}', maxLines: 1),
                onTap: () {
                  currentlyViewing = posts[index];
                  if (MediaQuery.of(context).size.width > MOBILE_BREAKPOINT) {
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
    // TODO: delete dummy data once we get the backend working
    return dummyData();

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

  List<Post> dummyData() {
    var andrew = User(
        id: 0,
        firstName: "Andrew",
        lastName: "Haberlandt",
        email: "crazy4sb@gmail.com");
    var adam = User(
        id: 1, firstName: 'Adam', lastName: 'Lis', email: 'lis.22@osu.edu');
    var alek = User(
        id: 2,
        firstName: 'Alek',
        lastName: 'Kundla',
        email: 'kundla.9@osu.edu');
    var max = User(
        id: 3,
        firstName: 'Max',
        lastName: 'Gruber',
        email: 'gruber.173@osu.edu',
        isInstructor: true);
    return [
      Post(
          author: andrew,
          id: 0,
          title: "Note Test",
          bodyMarkdown:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
      Post(
          author: andrew,
          id: 1,
          title: "Question Test",
          bodyMarkdown:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          answers: [
            Answer(
                id: 0,
                author: adam,
                bodyMarkdown: 'There are no dumb questions, only dumb people.',
                upvotes: 7),
            Answer(
                id: 1,
                author: alek,
                bodyMarkdown: 'I am smort.',
                upvotes: 9001),
            Answer(id: 2, author: max, bodyMarkdown: 'I like to cook.'),
          ]),
      Post(
          author: andrew,
          id: 2,
          title: "Question Test 2",
          bodyMarkdown:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          answers: [
            Answer(
                id: 3,
                author: adam,
                bodyMarkdown:
                    'Nevermind, there are dumb questions and this is one of them.')
          ]),
    ];
  }
}
