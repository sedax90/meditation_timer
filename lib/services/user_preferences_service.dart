import 'dart:convert';

import 'package:meditation_timer/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static final UserPreferencesService _singletonInstance = UserPreferencesService._privateConstructor();

  factory UserPreferencesService() => _singletonInstance;

  UserPreferencesService._privateConstructor();

  static const END_BELL_SOUND = "END_BELL_SOUND";
  static const VIBRATE_ON_END = "VIBRATE_ON_END";
  static const PRESETS = "PRESETS";

  static Future<void> setEndBellSound(final String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(END_BELL_SOUND, value);
  }

  static Future<String> getEndBellSound() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(END_BELL_SOUND) ?? "assets/audio/bells/bell-1.mp3";
  }

  static Future<void> setVibrateOnEnd(final bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(VIBRATE_ON_END, value);
  }

  static Future<bool> getVibrateOnEnd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(VIBRATE_ON_END) ?? false;
  }

  static Future<void> addPreset(final Preset value) async {
    final currentPresetsEncoded = await getPresets();

    int? toRemove;
    for (int i = 0; i < currentPresetsEncoded.length; i++) {
      final item = currentPresetsEncoded[i];
      if (item.backgroundSound == value.backgroundSound && item.speed == value.speed && item.timeSec == value.timeSec) {
        toRemove = i;
      }
    }

    if (toRemove != null) {
      currentPresetsEncoded.removeAt(toRemove);
    }

    currentPresetsEncoded.add(value);
    setPresets(currentPresetsEncoded);
  }

  static Future<void> setPresets(final List<Preset> presets) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> encoded = presets.map((e) => json.encode(e)).toList();
    await prefs.setStringList(PRESETS, encoded);
  }

  static Future<List<Preset>> getPresets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(PRESETS);
    if (encoded != null && encoded.isNotEmpty) {
      final items = encoded.map((e) => Preset.fromJson(json.decode(e))).toList();
      return items;
    } else {
      return [];
    }
  }
}
