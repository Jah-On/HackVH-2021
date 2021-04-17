import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = true;
  var _isFinished = false;
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!_isLoading &&
              !_isFinished &&
              snapshot.connectionState != ConnectionState.done &&
              (snapshot.hasError ||
                  snapshot.hasData && snapshot.data == null)) {
            return ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text("Sign in with Google"),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _openMain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void initState() {
    super.initState();
    _signInWithGoogle();

    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!_isFinished && user != null) {
        setState(() => _isFinished = true);
        _subscription.cancel();
        _openMain(context);
      }
    });
  }

  Future<UserCredential> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Trigger the authentication flow
      GoogleSignInAccount googleUser = await GoogleSignIn().signInSilently();

      if (googleUser == null) {
        GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
