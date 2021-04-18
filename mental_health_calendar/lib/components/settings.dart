import 'package:flutter/material.dart';
import 'package:mental_health_calendar/cubit/settings_cubit.dart';
import 'package:mental_health_calendar/util.dart';

class WeekdaysToggle extends StatelessWidget {
  static final List<String> days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

  final List<bool> selected;
  final void Function(List<bool>) onChange;

  const WeekdaysToggle({Key key, this.selected, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < days.length; i++)
          DayToggle(
            text: days[i],
            selected: selected[i],
            onChange: (value) => update(value, i),
          ),
      ],
    );
  }

  void update(bool value, int index) {
    final updatedSelected = List.of(selected);
    updatedSelected[index] = value;
    onChange(updatedSelected);
  }
}

class DayToggle extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function(bool) onChange;

  const DayToggle({
    @required this.text,
    @required this.selected,
    @required this.onChange,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).buttonTheme.colorScheme.primary;

    return selected
        ? MaterialButton(
            child: Text(text, style: Theme.of(context).accentTextTheme.button),
            minWidth: 0,
            elevation: 0.0,
            color: accent,
            shape: CircleBorder(),
            onPressed: () => onChange(!selected),
          )
        : MaterialButton(
            child: Text(text),
            minWidth: 0,
            elevation: 0.0,
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: CircleBorder(
                side: BorderSide(color: accent)),
            onPressed: () => onChange(!selected),
          );
  }
}

class TimeEditor extends StatelessWidget {
  final String label;
  final Duration value;
  final void Function(Duration) onChange;

  const TimeEditor({this.label, this.value, this.onChange, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime todayStart = Util.todayStart(DateTime.now());

    String time = Util.formatTime(todayStart.add(value));

    return OutlinedButton.icon(
      icon: Icon(Icons.edit),
      label: Text("$label $time"),
      onPressed: () async {
        TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: Util.todFromDuration(value),
        );
        if (picked != null) {
          onChange(Util.durationFromTOD(picked));
        }
      },
    );
  }
}

class HealthEventSettings extends StatelessWidget {
  final MentalHealthEvent event;
  final MentalHealthEventInfo info;
  final void Function(MentalHealthEvent) onChange;

  const HealthEventSettings({this.info, this.event, this.onChange, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(children: [
        ListTile(
          title: Text(info.name),
          trailing: Icon(info.icon),
        ),
        WeekdaysToggle(
          selected: event.days,
          onChange: (days) => onChange(
            event.copyWith(days: days),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TimeEditor(
              label: "Starts at",
              value: event.startTime,
              onChange: (value){
                onChange(event.copyWith(startTime: value));
              },
            ),
            TimeEditor(
              label: "Ends at",
              value: event.endTime,
              onChange: (value){
                onChange(event.copyWith(endTime: value));
              },
            )
          ],
        ),
      ]);
}
