import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mental_health_calendar/pages/questionare.dart';

part 'settings_cubit.g.dart';

@immutable
@JsonSerializable()
class MentalHealthEvent {
  final List<bool> days;
  final Duration startTime;
  final Duration endTime;

  MentalHealthEvent({this.days, this.startTime, this.endTime}) {
    assert(days.length == 7);
  }

  MentalHealthEvent copyWith({
    List<bool> days,
    Duration startTime,
    Duration endTime,
  }) {
    return MentalHealthEvent(
      days: days ?? this.days,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  factory MentalHealthEvent.fromJson(Map<String, dynamic> json) =>
      _$MentalHealthEventFromJson(json);
  Map<String, dynamic> toJson() => _$MentalHealthEventToJson(this);

  bool occursToday() {
    // Monady is 1
    // Sunay is 7%7 = 0
    final weekday = DateTime.now().weekday;
    return days[weekday % 7];
  }
}

@immutable
class MentalHealthEventInfo {
  final String name;
  final IconData icon;
  final void Function(BuildContext) action;

  MentalHealthEventInfo({this.name, this.icon, this.action});
}

@immutable
@JsonSerializable()
class SettingsState {
  @JsonKey(defaultValue: "system")
  final String themeMode;

  final MentalHealthEvent checkIn;
  static final MentalHealthEventInfo checkInInfo = MentalHealthEventInfo(
      name: "Mental Health Check",
      icon: Icons.alarm_on,
      action: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarePage(),
            maintainState: false,
          ),
        );
      });

  final MentalHealthEvent exercise;
  static final MentalHealthEventInfo exerciseInfo = MentalHealthEventInfo(
    name: "Exercise",
    icon: Icons.directions_run,
  );

  SettingsState({
    String themeMode,
    MentalHealthEvent checkIn,
    MentalHealthEvent exercise,
  })  : themeMode = themeMode ?? "system",
        checkIn = checkIn ??
            MentalHealthEvent(
              days: [false, false, false, false, false, false, true],
              startTime: Duration(hours: 19),
              endTime: Duration(hours: 19, minutes: 10),
            ),
        exercise = exercise ??
            MentalHealthEvent(
              days: [false, true, false, true, false, true, false],
              startTime: Duration(hours: 17),
              endTime: Duration(hours: 17, minutes: 30),
            );

  SettingsState copyWith({
    String themeMode,
    MentalHealthEvent checkIn,
    MentalHealthEvent exercise,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      checkIn: checkIn ?? this.checkIn,
      exercise: exercise ?? this.exercise,
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return _$SettingsStateFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  @override
  SettingsState fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SettingsState state) => state.toJson();
}
