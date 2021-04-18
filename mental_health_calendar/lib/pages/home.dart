import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_calendar/components/calendar_event_list.dart';
import 'package:mental_health_calendar/cubit/google_cubit.dart';
import 'package:mental_health_calendar/pages/questionare.dart';

import 'settings.dart';

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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: BlocBuilder<GoogleCubit, GoogleState>(
        builder: (context, state) => RefreshIndicator(
          // onRefresh: (state is GoogleAuthenticated &&
          //         !(state is GoogleCalendarLoading))
          //     ? BlocProvider.of<GoogleCubit>(context).loadCalendar
          //     : () => Future.delayed(Duration(seconds: 5)),
          onRefresh: BlocProvider.of<GoogleCubit>(context).loadCalendar,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              if (state is GoogleAuthenticated) ...[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Welcome, ${state.googleUser.displayName}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
              CalendarEventList(),
            ],
          ),
        ),
      ),
    );
  }
}
