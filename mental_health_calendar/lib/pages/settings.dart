import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_calendar/components/settings.dart';
import 'package:mental_health_calendar/cubit/google_cubit.dart';
import 'package:mental_health_calendar/cubit/settings_cubit.dart';
import 'package:mental_health_calendar/pages/login.dart';

class SettingsPage extends StatelessWidget {
  static final settingsBox = "settings";
  static final themeKey = "theme";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => ListView(
          children: <Widget>[
            ListTile(
              title: Text("SYSTEM", style: _groupStyle(context)),
              dense: true,
            ),
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
            BlocBuilder<GoogleCubit, GoogleState>(
              builder: (context, state) {
                if (state is GoogleAuthenticated) {
                  return ListTile(
                    title: Text("Signed in as ${state.googleUser.displayName}"),
                    subtitle: Text("(${state.googleUser.email})"),
                    trailing: OutlinedButton(
                      child: Text("Sign Out"),
                      onPressed: () {
                        BlocProvider.of<GoogleCubit>(context).signOut();
                        while (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Divider(thickness: 1.5),
            ListTile(
              title: Text("SCHEDULING", style: _groupStyle(context)),
              dense: true,
            ),
            Divider(),
            HealthEventSettings(
              event: state.checkIn,
              info: SettingsState.checkInInfo,
              onChange: (value) => BlocProvider.of<SettingsCubit>(context)
                  .emit(state.copyWith(checkIn: value)),
            ),
            Divider(),
            HealthEventSettings(
              event: state.exercise,
              info: SettingsState.exerciseInfo,
              onChange: (value) => BlocProvider.of<SettingsCubit>(context)
                  .emit(state.copyWith(exercise: value)),
            ),
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
