import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static final DateFormat dateTimeFormat = DateFormat("M/dd/yyyy h:mm a");
  static final DateFormat timeFormat = DateFormat("h:mm a");

  static DateTime getDate(DateTime dateTime) {
    return dateTime.subtract(Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
      milliseconds: dateTime.millisecond,
      microseconds: dateTime.microsecond,
    ));
  }

  static DateTime todayStart(DateTime now) => getDate(DateTime.now());

  static DateTime todayEnd(DateTime now) =>
      todayStart(now).add(Duration(days: 1));

  static Duration durationFromTOD(TimeOfDay timeOfDay) =>
      Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

  static TimeOfDay todFromDuration(Duration duration) => TimeOfDay(
        hour: duration.inHours,
        minute: duration.inMinutes % Duration.minutesPerHour,
      );

  static String formatTime(DateTime time) {
    return timeFormat.format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return dateTimeFormat.format(dateTime);
  }
}
