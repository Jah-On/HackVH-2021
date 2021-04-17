import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'cubit/google_cubit.dart';
import 'cache_provider.dart';
import 'pages/login.dart';
import 'pages/settings.dart';

void main() async {
  await Settings.init(
    cacheProvider: HiveCache(SettingsPage.settingsBox),
  );
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleCubit(),
      child: ValueListenableBuilder(
        valueListenable: Hive.box(SettingsPage.settingsBox).listenable(),
        builder: (context, box, widget) {
          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            themeMode: _getTheme(box),
            home: LoginPage(),
          );
        },
      ),
    );
  }

  ThemeMode _getTheme(Box box) {
    final value = box.get(SettingsPage.themeKey);
    final theme = {
          "dark": ThemeMode.dark,
          "light": ThemeMode.light,
          "system": ThemeMode.system,
        }[value] ??
        ThemeMode.system;

    return theme;
  }
}
