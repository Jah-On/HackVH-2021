import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_cubit.g.dart';

@immutable
@JsonSerializable()
class HealthEventState {
  final List<bool> days;
  final Duration duration;

  const HealthEventState({this.days, this.duration});

  HealthEventState copyWith({
    List<bool> days,
    Duration duration,
  }) {
    return HealthEventState(
      days: days ?? this.days,
      duration: duration ?? this.duration,
    );
  }

  factory HealthEventState.fromJson(Map<String, dynamic> json) =>
      _$HealthEventStateFromJson(json);
  Map<String, dynamic> toJson() => _$HealthEventStateToJson(this);
}

@immutable
@JsonSerializable()
class SettingsState {
  @JsonKey(defaultValue: "system")
  final String themeMode;

  final HealthEventState checkIn;

  const SettingsState({this.themeMode, this.checkIn});

  SettingsState copyWith({
    String themeMode,
    HealthEventState checkIn,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      checkIn: checkIn ?? this.checkIn,
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
  SettingsState fromJson(Map<String, dynamic> json) {
    SettingsState state = SettingsState.fromJson(json);
    if (state.checkIn == null) {
      state = state.copyWith(
        checkIn: HealthEventState(
          days: [false, false, false, false, false, false, true],
          duration: Duration(minutes: 10),
        ),
      );
    }
    return state;
  }

  @override
  void onChange(Change<SettingsState> change) {
    super.onChange(change);
    print("State changed: ${jsonEncode(state.toJson())}");
  }

  @override
  Map<String, dynamic> toJson(SettingsState state) => state.toJson();
}
