import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_calendar/cubit/google_cubit.dart';
import 'package:mental_health_calendar/cubit/settings_cubit.dart';
import 'package:mental_health_calendar/pages/questionare.dart';
import 'package:mental_health_calendar/util.dart';

class CalendarEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<GoogleCubit, GoogleState>(
          builder: (context, state) {
            if (state is GoogleCalendarLoaded) {
              final allEvents = combineEvents(state, settingsState);

              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allEvents.length,
                  itemBuilder: (context, index) =>
                      _EventTile(event: allEvents[index]));
            } else {
              return Center(child: LinearProgressIndicator());
            }
          },
        );
      },
    );
  }

  List<_Event> combineEvents(
    GoogleCalendarLoaded google,
    SettingsState settings,
  ) {
    final allEvents = google.events.map((e) => _Event.fromGoogle(e)).toList();

    allEvents.add(_Event.fromMentalHealthEvent(
      settings.checkIn,
      SettingsState.checkInInfo,
    ));

    allEvents.add(_Event.fromMentalHealthEvent(
      settings.exercise,
      SettingsState.exerciseInfo,
    ));

    allEvents.removeWhere((e) => e == null);

    allEvents.sort((a, b) {
      if (a.isAllDay && b.isAllDay) return 0;
      if (a.isAllDay) return -1;
      if (b.isAllDay) return 1;

      return a.start.compareTo(b.start);
    });

    return allEvents;
  }
}

@immutable
class _Event {
  final bool isMentalHealthEvent;
  final bool isAllDay;
  final DateTime start;
  final DateTime end;
  final String name;
  final IconData icon;
  final Widget Function(BuildContext) action;

  _Event(
      {this.isMentalHealthEvent,
      this.isAllDay,
      this.start,
      this.end,
      this.name,
      this.icon,
      this.action});

  _Event.fromGoogle(Event event)
      : this(
          isMentalHealthEvent: false,
          isAllDay: event.start.date != null,
          start: event.start.dateTime,
          end: event.end.dateTime,
          name: event.summary,
          icon: Icons.calendar_today,
        );

  static _Event fromMentalHealthEvent(
    MentalHealthEvent event,
    MentalHealthEventInfo info,
  ) {
    if (event.occursToday()) {
      final todayStart = Util.todayStart(DateTime.now());

      return _Event(
        isMentalHealthEvent: false,
        isAllDay: false,
        start: todayStart.add(event.startTime),
        end: todayStart.add(event.endTime),
        name: info.name,
        icon: info.icon,
        action: info.action == null
            ? null
            : (context) => OutlinedButton(
                  child: Text("Do it"),
                  onPressed: () => info.action(context),
                ),
      );
    } else {
      return null;
    }
  }
}

class _EventTile extends StatelessWidget {
  final _Event event;

  const _EventTile({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subtitle;
    if (event.isAllDay) {
      subtitle = "All Day";
    } else {
      final now = DateTime.now();

      final startTime = event.start.toLocal();
      final endTime = event.end.toLocal();

      final todayStartDate = Util.todayStart(now);
      final todayEndDate = Util.todayEnd(now);

      final start = startTime.isBefore(todayStartDate)
          ? Util.formatDateTime(startTime)
          : Util.formatTime(startTime);
      final end = endTime.isAfter(todayEndDate)
          ? Util.formatDateTime(endTime)
          : Util.formatTime(endTime);
      subtitle = "$start - $end";
    }

    return Card(
      child: ListTile(
        title: Text("${event.name}"),
        leading: Icon(event.icon),
        trailing: event.action == null ? null : event.action(context),
        subtitle: Text(subtitle),
      ),
    );
  }
}
