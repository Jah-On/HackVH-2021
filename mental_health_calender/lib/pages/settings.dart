import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  static final settingsBox = "settings";
  static final themeKey = "theme";

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      children: <Widget>[
        DropDownSettingsTile<String>(
          title: "Theme",
          settingKey: "theme",
          values: <String, String>{
            "dark": "Dark",
            "light": "Light",
            "system": "System",
          },
          selected: "system",
        )
      ],
    );
  }
}
