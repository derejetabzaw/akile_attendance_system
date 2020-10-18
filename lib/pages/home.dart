import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  //  change inital load state to true and log out the user
                  logout();
                })
          ],
        ),
        body: Center(
            child: Text("Welcome to Akile attendance management system")));
  }

  void logout() async {
    try {
      // logout the user
      // change loading state to false
      // route to Login page
      Navigator.of(context).pushReplacementNamed('login');
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
