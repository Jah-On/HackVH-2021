import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A cache access provider class for shared preferences using Hive library
class HiveCache extends CacheProvider {
  Box preferences;
  final String keyName;

  HiveCache(this.keyName);

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    preferences = await Hive.openBox(keyName);
  }

  Set get keys => getKeys();

  @override
  bool getBool(String key) {
    return preferences.get(key);
  }

  @override
  double getDouble(String key) {
    return preferences.get(key);
  }

  @override
  int getInt(String key) {
    return preferences.get(key);
  }

  @override
  String getString(String key) {
    return preferences.get(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return preferences.put(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return preferences.put(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return preferences.put(key, value);
  }

  @override
  Future<void> setString(String key, String value) {
    return preferences.put(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    return preferences.put(key, value);
  }

  @override
  bool containsKey(String key) {
    return preferences.containsKey(key);
  }

  @override
  Set getKeys() {
    return preferences.keys.toSet();
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await preferences.delete(key);
    }
  }

  @override
  Future<void> removeAll() async {
    final keys = getKeys();
    await preferences.deleteAll(keys);
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    var value = preferences.get(key);
    if (value is T) {
      return value;
    }
    return defaultValue;
  }
}
