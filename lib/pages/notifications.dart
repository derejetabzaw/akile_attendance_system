import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationsPage());
  }
}

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.title}) : super(key: key);

  final String title;

  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2;
        return _buildRow(index);

      }
    );
  }

  Widget _buildRow(index) {
    return ListTile(
        title: Text("Notifications list")
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList()
    );
  }
}
