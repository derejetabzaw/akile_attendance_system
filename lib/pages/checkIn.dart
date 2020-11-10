import 'package:flutter/material.dart';

class CheckIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CheckInPage());
  }
}

class CheckInPage extends StatefulWidget {
  CheckInPage({Key key, this.title}) : super(key: key);

  final String title;

  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  Widget build(BuildContext context) {

    final checkInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          // Check user credentials are correct and route to the home screen
          Navigator.of(context).pushReplacementNamed('home');
        },
        child: Text(
          "CheckIn",
          textAlign: TextAlign.center,
        ),
      ),
    );

    final checkOutButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          // Check user credentials are correct and route to the home screen
          Navigator.of(context).pushReplacementNamed('home');
        },
        child: Text(
          "CheckOut",
          textAlign: TextAlign.center,
        ),
      ),
    );

    final userImage = Center(
        child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.black)),
            child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/logo.jpg"),
                        fit: BoxFit.cover)))));

    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.0),
                userImage,
                SizedBox(height: 35.0),
                checkInButton,
                SizedBox(height: 15.0),
                checkOutButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
