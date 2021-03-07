import 'package:flutter/material.dart';
import 'package:frontend/views/post_content_view.dart';

import '../model/post.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Stolen from https://github.com/ahmed-alzahrani/Flutter_Simple_Login/blob/master/lib/main.dart
class LoginPage extends StatefulWidget {
  LoginPage(this.onToken);
  final ValueChanged<String> onToken;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _firstNameFilter = new TextEditingController();
  final TextEditingController _lastNameFilter = new TextEditingController();

  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  bool loading = false;

  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _firstNameFilter.addListener(_firstNameListen);
    _lastNameFilter.addListener(_lastNameListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _firstNameListen() {
    if (_firstNameFilter.text.isEmpty) {
      _firstName = "";
    } else {
      _firstName = _firstNameFilter.text;
    }
  }

  void _lastNameListen() {
    if (_lastNameFilter.text.isEmpty) {
      _lastName = "";
    } else {
      _lastName = _lastNameFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ));
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Login"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    var fields = [
      new Container(
        child: new TextField(
          controller: _emailFilter,
          decoration: new InputDecoration(labelText: 'Email'),
        ),
      ),
      new Container(
        child: new TextField(
          controller: _passwordFilter,
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
      )
    ];
    if (_form == FormType.register) {
      fields.add(new Container(
        child: new TextField(
          controller: _firstNameFilter,
          decoration: new InputDecoration(labelText: 'First Name'),
        ),
      ));
      fields.add(new Container(
        child: new TextField(
          controller: _lastNameFilter,
          decoration: new InputDecoration(labelText: 'Last Name'),
        ),
      ));
    }
    return new Container(
      child: new Column(
        children: fields,
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : new TextButton(
                    child: new Text('Login'),
                    onPressed: _loginPressed,
                  ),
            new TextButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new TextButton(
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : new TextButton(
                    child: new Text('Create an Account'),
                    onPressed: _createAccountPressed,
                  ),
            new TextButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  void _loginPressed() async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    print('The user wants to login with $_email and $_password');

    final response = await http.post(
      Uri.http(env['API_HOST'], 'GetAuthToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': _email, 'password': _password}),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> rJSON = jsonDecode(response.body);
      if (rJSON.containsKey('token')) {
        // We have token, return
        widget.onToken(rJSON['token']);
      }
      setState(() {
        loading = false;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  void _createAccountPressed() {
    if (loading) return;
    print('The user wants to create an accoutn with $_email and $_password');
  }

  void _passwordReset() {
    if (loading) return;
    print("The user wants a password reset request sent to $_email");
  }
}
