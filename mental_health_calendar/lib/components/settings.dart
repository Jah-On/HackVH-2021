import 'package:flutter/material.dart';
import 'package:mental_health_calendar/cubit/settings_cubit.dart';

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
    return MaterialButton(
      child: Text(text),
      minWidth: 0,
      elevation: 1.0,
      color: selected
          ? Theme.of(context).accentColor
          : Theme.of(context).hoverColor,
      shape: CircleBorder(),
      onPressed: () => onChange(!selected),
    );
  }
}

class HealthEventSettings extends StatelessWidget {
  final String name;
  final HealthEventState state;
  final void Function(HealthEventState) onChange;

  const HealthEventSettings({this.name, this.state, this.onChange, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(children: [
        ListTile(title: Text(name)),
        WeekdaysToggle(
          selected: state.days,
          onChange: (days) => onChange(
            state.copyWith(days: days),
          ),
        ),
      ]);
}
