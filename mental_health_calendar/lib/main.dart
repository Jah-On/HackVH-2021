import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'cubit/google_cubit.dart';
import 'cubit/settings_cubit.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GoogleCubit()),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
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
            themeMode: _getTheme(state),
            home: LoginPage(),
          );
        },
      ),
    );
  }

  ThemeMode _getTheme(SettingsState state) =>
      {
        "dark": ThemeMode.dark,
        "light": ThemeMode.light,
        "system": ThemeMode.system,
      }[state.themeMode] ??
      ThemeMode.system;
}
