import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_calender/cubit/calender_cubit.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GoogleCubit, GoogleState>(
        builder: (context, state) {
          if (state is GoogleUnauthenticated) {
            if (state.error != null) {
              print(state.error);
            }

            return Center(
              child: ElevatedButton(
                onPressed: BlocProvider.of<GoogleCubit>(context).login,
                child: Text("Sign in with Google"),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void didChangeDependencies() {
    if (_subscription != null) _subscription.cancel();

    _subscription = BlocProvider.of<GoogleCubit>(context).stream.listen(
      (state) {
        if (state is GoogleAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

          _subscription.cancel();
          _subscription = null;
        }
      },
    );

    super.didChangeDependencies();
  }
}
