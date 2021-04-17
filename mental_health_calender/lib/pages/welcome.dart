import 'package:flutter/material.dart';

import 'home.dart';

class WelcomePage extends StatelessWidget {
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
                onPressed: () => openMain(context),
                child: Text("Sign in with Google"),
              ),
              TextButton(
                onPressed: () => openMain(context),
                child: Text("Skip"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void openMain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
