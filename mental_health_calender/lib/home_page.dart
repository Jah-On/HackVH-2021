import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  static final format = DateFormat("EEEE, MMMM d");

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(format.format(now)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text("School"),
            subtitle: Text("8:15 AM - 3:35 PM"),
          ),
        ),
      ),
    );
  }
}
