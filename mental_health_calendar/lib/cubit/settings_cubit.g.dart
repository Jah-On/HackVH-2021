// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MentalHealthEvent _$MentalHealthEventFromJson(Map<String, dynamic> json) {
  return MentalHealthEvent(
    days: (json['days'] as List)?.map((e) => e as bool)?.toList(),
    startTime: json['startTime'] == null
        ? null
        : Duration(microseconds: json['startTime'] as int),
    endTime: json['endTime'],
  );
}

Map<String, dynamic> _$MentalHealthEventToJson(MentalHealthEvent instance) =>
    <String, dynamic>{
      'days': instance.days,
      'startTime': instance.startTime?.inMicroseconds,
      'endTime': instance.endTime?.inMicroseconds,
    };

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) {
  return SettingsState(
    themeMode: json['themeMode'] as String ?? 'system',
    checkIn: json['checkIn'] == null
        ? null
        : MentalHealthEvent.fromJson(json['checkIn'] as Map<String, dynamic>),
    exercise: json['exercise'] == null
        ? null
        : MentalHealthEvent.fromJson(json['exercise'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'checkIn': instance.checkIn,
      'exercise': instance.exercise,
    };
