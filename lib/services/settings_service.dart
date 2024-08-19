import 'package:meditation_timer/models.dart';

class SettingsService {
  static final SettingsService _singletonInstance = SettingsService._privateConstructor();

  factory SettingsService() => _singletonInstance;

  SettingsService._privateConstructor();

  static List<BackgroundSound> getBackgroundSounds() {
    return [
      BackgroundSound(title: "None", asset: ""),
      BackgroundSound(title: "Omh", asset: "assets/audio/backgrounds/ohm.mp3"),
      BackgroundSound(title: "So Ham", asset: "assets/audio/backgrounds/so-ham.mp3"),
      BackgroundSound(title: "Heavy rain", asset: "assets/audio/backgrounds/heavy-rain-nature-sounds-8186.mp3"),
      BackgroundSound(
          title: "Nature birds", asset: "assets/audio/backgrounds/nature-birds-ambiance-morning-kisses-214774.mp3"),
      BackgroundSound(title: "Dripping water", asset: "assets/audio/backgrounds/dripping-water-nature-sounds-8050.mp3"),
      BackgroundSound(title: "Beach", asset: "assets/audio/backgrounds/soft-waves-on-the-beach-sound-190884.mp3"),
    ];
  }

  static List<Speed> getSpeeds() {
    return [
      Speed(title: "Very Slow", value: 0.5),
      Speed(title: "Slow", value: 0.75),
      Speed(title: "Normal", value: 1.0),
      Speed(title: "Fast", value: 1.25),
      Speed(title: "Very fast", value: 1.5),
    ];
  }

  static List<BellSound> getBellSounds() {
    return [
      BellSound(title: "Bell 1", asset: "assets/audio/bells/bell-1.mp3"),
      BellSound(title: "Bell 2", asset: "assets/audio/bells/bell-2.mp3"),
      BellSound(title: "Bell 3", asset: "assets/audio/bells/bell-3.mp3"),
      BellSound(title: "Bell 4", asset: "assets/audio/bells/bell-4.mp3"),
    ];
  }
}
