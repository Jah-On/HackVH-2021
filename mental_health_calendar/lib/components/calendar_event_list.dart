import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_calendar/cubit/google_cubit.dart';

class CalendarEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleCubit, GoogleState>(
      builder: (context, state) {
        if (state is GoogleCalendarLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.events.length,
            itemBuilder: (context, index) => _EventTile(
              state: state,
              event: state.events[index],
            ),
          );
        } else {
          return Center(child: LinearProgressIndicator());
        }
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  static final DateFormat dateTimeFormat = DateFormat("M/dd/yyyy h:mm a");
  static final DateFormat timeFormat = DateFormat("h:mm a");

  final GoogleCalendarLoaded state;
  final Event event;

  const _EventTile({Key key, this.state, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subtitle;
    if (event.start.date != null) {
      subtitle = "All Day";
    } else {
      final startTime = event.start.dateTime.toLocal();
      final endTime = event.end.dateTime.toLocal();

      final start = startTime.isBefore(state.todayStart)
          ? dateTimeFormat.format(startTime)
          : timeFormat.format(startTime);
      final end = endTime.isAfter(state.todayEnd)
          ? dateTimeFormat.format(endTime)
          : timeFormat.format(endTime);
      subtitle = "$start - $end";
    }

    return Card(
      child: ListTile(
        title: Text("${event.summary}"),
        subtitle: Text(subtitle),
      ),
    );
  }
}
