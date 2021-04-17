// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthEventState _$HealthEventStateFromJson(Map<String, dynamic> json) {
  return HealthEventState(
    days: (json['days'] as List)?.map((e) => e as bool)?.toList(),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  );
}

Map<String, dynamic> _$HealthEventStateToJson(HealthEventState instance) =>
    <String, dynamic>{
      'days': instance.days,
      'duration': instance.duration?.inMicroseconds,
    };

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) {
  return SettingsState(
    themeMode: json['themeMode'] as String ?? 'system',
    checkIn: json['checkIn'] == null
        ? null
        : HealthEventState.fromJson(json['checkIn'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'checkIn': instance.checkIn,
    };
