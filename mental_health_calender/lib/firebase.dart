import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseLoader extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final Widget child;
  FirebaseLoader(this.child);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Card(
              child: ListTile(
                title: Text("Error"),
                subtitle: Text(snapshot.error.toString()),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return child;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
