import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text("Welcome to mental_health_calender!",
                  textAlign: TextAlign.center),
              Spacer(),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        try {
                          await _signInWithGoogle();
                        } finally {
                          setState(() => _isLoading = false);
                        }
                        _openMain(context);
                      },
                child: Text("Sign in with Google"),
              ),
              StreamBuilder<User>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "Error: ${snapshot.error}",
                      style: Theme.of(context).textTheme.bodyText1,
                    );
                  } else {
                    return Text(
                      "User: ${snapshot.data}",
                      style: Theme.of(context).textTheme.bodyText1,
                    );
                  }
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _openMain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  // TODO: use signInSilently to auto sign-in
  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

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
  }
}
