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
        },
        child: Text(
          "CheckOut",
          textAlign: TextAlign.center,
        ),
      ),
    );

    workedHours() {
      return Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          width: 200,
          height: 200,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total Worked hours",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "18:00",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 3),
            borderRadius: BorderRadius.all(
              Radius.circular(200),
            ),
          ),
        ),
      );
    }

    // final userImage = Center(
    //     child: Container(
    //         padding: EdgeInsets.all(4),
    //         decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             border: Border.all(width: 1, color: Colors.black)),
    //         child: Container(
    //             height: 200,
    //             width: 200,
    //             decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 image: DecorationImage(
    //                     image: AssetImage("assets/logo.jpg"),
    //                     fit: BoxFit.cover)))));

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
                workedHours(),
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
