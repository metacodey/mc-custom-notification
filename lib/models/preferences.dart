// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

/// A class for managing application preferences using [SharedPreferences].
///
/// [Preferences] provides static methods to interact with and store key-value
/// pairs persistently across application sessions. It supports various data types
/// such as booleans, strings, lists of strings, and integers.
class Preferences {
  /// The key for storing the project ID.
  static const projectId = "projectId";

  /// The key for storing the service account information.
  static const serviceAccount = "serviceAccount";

  /// The instance of [SharedPreferences] used for accessing and storing preferences.
  static late SharedPreferences pref;

  /// Initializes the [SharedPreferences] instance.
  ///
  /// This must be called before any other methods to ensure [pref] is properly
  /// instantiated.
  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  /// Retrieves a boolean value from preferences for the given [key].
  ///
  /// Returns `false` if the key does not exist or the value is not set.
  static bool getBoolean(String key) {
    return pref.getBool(key) ?? false;
  }

  /// Stores a boolean value in preferences for the given [key].
  ///
  /// [value] is the boolean value to be stored.
  static Future<void> setBoolean(String key, bool value) async {
    await pref.setBool(key, value);
  }

  /// Prints all the keys in the preferences.
  ///
  /// This method is useful for debugging purposes to see all stored keys.
  static Future<void> printAll() async {
    var keys = pref.getKeys();
    print(keys);
  }

  /// Retrieves a string value from preferences for the given [key].
  ///
  /// Returns an empty string if the key does not exist or the value is not set.
  static String getString(String key) {
    return pref.getString(key) ?? "";
  }

  /// Stores a string value in preferences for the given [key].
  ///
  /// [value] is the string value to be stored.
  static Future<void> setString(String key, String value) async {
    await pref.setString(key, value);
  }

  /// Stores a list of strings in preferences for the given [key].
  ///
  /// [value] is the list of strings to be stored. If [value] is `null`, an empty list
  /// is stored.
  static Future<void> setListString(String key, List<String>? value) async {
    await pref.setStringList(key, value ?? []);
  }

  /// Retrieves a list of strings from preferences for the given [key].
  ///
  /// Returns an empty list if the key does not exist or the value is not set.
  static List<String> getListString(String key) {
    return pref.getStringList(key) ?? [];
  }

  /// Retrieves an integer value from preferences for the given [key].
  ///
  /// Returns `0` if the key does not exist or the value is not set.
  static int getInt(String key) {
    return pref.getInt(key) ?? 0;
  }

  /// Stores an integer value in preferences for the given [key].
  ///
  /// [value] is the integer value to be stored.
  static Future<void> setInt(String key, int value) async {
    await pref.setInt(key, value);
  }

  /// Clears all stored preferences.
  ///
  /// This removes all key-value pairs from the preferences.
  static Future<void> clearSharPreference() async {
    await pref.clear();
  }

  /// Removes a specific key-value pair from preferences.
  ///
  /// [key] is the key of the pair to be removed.
  static Future<void> clearKeyData(String key) async {
    await pref.remove(key);
  }
}
