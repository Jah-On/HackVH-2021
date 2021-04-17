import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_calendar/components/settings.dart';
import 'package:mental_health_calendar/cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  static final settingsBox = "settings";
  static final themeKey = "theme";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => ListView(
          children: <Widget>[
            ListTile(title: Text("SYSTEM", style: _groupStyle(context))),
            ListTile(
              title: Text("Theme"),
              trailing: DropdownButton(
                items: ["dark", "light", "system"]
                    .map(
                      (value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ),
                    )
                    .toList(),
                value: state.themeMode,
                underline: Container(),
                onChanged: (value) {
                  final settings = BlocProvider.of<SettingsCubit>(context);
                  settings.emit(settings.state.copyWith(themeMode: value));
                },
              ),
            ),
            ListTile(title: Text("SCHEDULING", style: _groupStyle(context))),
            HealthEventSettings(
                name: "Mental Health Check-In",
                state: state.checkIn,
                onChange: (value) => BlocProvider.of<SettingsCubit>(context)
                    .emit(state.copyWith(checkIn: value))),
          ],
        ),
      ),
    );
  }

  TextStyle _groupStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );
  }
}
