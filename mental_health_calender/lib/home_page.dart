import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now  = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(now.toString())
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),),
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
