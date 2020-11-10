import 'package:flutter/material.dart';

class Assignments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AssignmentsPage());
  }
}

class AssignmentsPage extends StatefulWidget {
  AssignmentsPage({Key key, this.title}) : super(key: key);

  final String title;

  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {

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
        title: Text("assignments list")
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList()
    );
  }
}
