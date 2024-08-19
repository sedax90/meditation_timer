import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_timer/models.dart';
import 'package:meditation_timer/screens/home_screen/widgets/circular_timer.dart';
import 'package:meditation_timer/screens/home_screen/widgets/home_header.dart';
import 'package:meditation_timer/screens/presets_screen/presets.dart';
import 'package:meditation_timer/services/settings_service.dart';
import 'package:meditation_timer/services/user_preferences_service.dart';
import 'package:meditation_timer/themes/app_theme.dart';
import 'package:meditation_timer/widgets/save_preset_form.dart';
import 'package:meditation_timer/widgets/selection_slider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _timerActive = false;
  late final AudioPlayer player;
  List<BackgroundSound> _backgroundSounds = [];
  List<Speed> _speeds = [];
  late BackgroundSound _selectedBackgroundSound;
  late Speed _selectedSpeed;
  final GlobalKey<SelectionSliderState> _backgroundSoundSlider = GlobalKey();
  final GlobalKey<SelectionSliderState> _speedSlider = GlobalKey();
  final GlobalKey<CircularTimerState> _circulartTimerKey = GlobalKey();

  @override
  initState() {
    super.initState();

    player = AudioPlayer();
    _backgroundSounds = SettingsService.getBackgroundSounds();
    _speeds = SettingsService.getSpeeds();

    _selectedBackgroundSound = _backgroundSounds.first;
    _selectedSpeed = _speeds.firstWhere((e) => e.value == 1.0);
  }

  @override
  dispose() async {
    super.dispose();

    if (player.playing) {
      player.stop();
    }
    await player.dispose();
  }

  Future<void> _onTimerStart() async {
    setState(() {
      _timerActive = true;
    });

    if (_selectedBackgroundSound.asset.isNotEmpty) {
      await player.setAsset(_selectedBackgroundSound.asset);
      await player.setVolume(1.0);
      await player.setLoopMode(LoopMode.off);
      await player.play();

      await player.setSpeed(_selectedSpeed.value);
    }
  }

  Future<void> _onTimerPause() async {
    await player.pause();
  }

  Future<void> _onTimerResume() async {
    await player.play();
  }

  Future<void> _onTimerStop() async {
    await player.stop();

    setState(() {
      _timerActive = false;
    });
  }

  Future<void> _onTimerFinish() async {
    if (player.playing) {
      await fadeOutAndStop(player.volume);
      await player.stop();
    }

    await Future.delayed(const Duration(milliseconds: 750), () async {
      final vibrateOnEnd = await UserPreferencesService.getVibrateOnEnd();
      if (vibrateOnEnd) {
        final hasVibration = await Vibration.hasVibrator();
        if (hasVibration == true) {
          Vibration.vibrate(duration: 800);
        }
      }

      String bellSound = await UserPreferencesService.getEndBellSound();
      await player.setAsset(bellSound);
      await player.setVolume(1.0);
      await player.setSpeed(1.0);
      await player.setLoopMode(LoopMode.off);
      await player.play();
    });

    setState(() {
      _timerActive = false;
    });
  }

  Future<void> fadeOutAndStop(final double startVolume) async {
    final Completer completer = Completer<void>();

    const Duration total = Duration(seconds: 3);
    Duration step = const Duration(milliseconds: 25);
    int i = 0;

    Timer.periodic(step, (timer) async {
      i++;
      final percent = (i * step.inMilliseconds) / total.inMilliseconds;
      final newVolume = startVolume - (percent * startVolume);
      await player.setVolume(newVolume);

      if (step.inMilliseconds * i >= total.inMilliseconds || player.volume == 0) {
        timer.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }

  void _onBackgroundSelect(final BackgroundSound sound) {
    setState(() {
      _selectedBackgroundSound = sound;
    });
  }

  void _onSpeedSelect(final Speed speed) {
    setState(() {
      _selectedSpeed = speed;
    });
  }

  void _openPresets() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Wrap(
            children: [
              Presets(
                onPresetSelect: (preset) {
                  Navigator.pop(context);
                  _setPreset(preset);
                },
              )
            ],
          );
        });
  }

  void _setPreset(final Preset preset) {
    _selectedBackgroundSound = _backgroundSounds.firstWhere((e) => e.asset == preset.backgroundSound);
    _selectedSpeed = _speeds.firstWhere((e) => e.value == preset.speed);

    _backgroundSoundSlider.currentState!.setSelectedItem(_selectedBackgroundSound);
    _speedSlider.currentState!.setSelectedItem(_selectedSpeed);
    _circulartTimerKey.currentState!.setTime(preset.timeSec);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Using preset ${preset.name}")));
  }

  Future<void> _addPreset() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                SavePresetForm(
                  onPresetNameSubmit: (name) async {
                    Navigator.pop(context);

                    await UserPreferencesService.addPreset(Preset(
                      name: name,
                      timeSec: _circulartTimerKey.currentState!.getTimeSec(),
                      backgroundSound: _selectedBackgroundSound.asset,
                      speed: _selectedSpeed.value,
                    ));

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Preset $name saved!")));
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: const HomeHeader(),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, MediaQuery.of(context).size.width * 0.45),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(54, 131, 104, 1),
                            Color.fromRGBO(12, 29, 23, 1),
                          ],
                          stops: [0, 0.75],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: _timerActive ? 0.5 : 1.0,
                                  child: Bounceable(
                                    onTap: _timerActive ? null : _openPresets,
                                    child: SvgPicture.asset("assets/images/presets.svg"),
                                  ),
                                ),
                                Bounceable(
                                  onTap: _addPreset,
                                  child: SvgPicture.asset("assets/images/heart_empty.svg"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: SelectionSlider<BackgroundSound>(
                              key: _backgroundSoundSlider,
                              title: "Background sound",
                              items: _backgroundSounds,
                              defaultSelectedItem: _selectedBackgroundSound,
                              onItemSelect: _onBackgroundSelect,
                              disabled: _timerActive,
                            ),
                          ),
                          SelectionSlider<Speed>(
                            key: _speedSlider,
                            title: "Speed",
                            items: _speeds,
                            defaultSelectedItem: _selectedSpeed,
                            onItemSelect: _onSpeedSelect,
                            disabled: _timerActive || _selectedBackgroundSound.asset.isEmpty,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CircularTimer(
                      key: _circulartTimerKey,
                      onStart: _onTimerStart,
                      onPause: _onTimerPause,
                      onResume: _onTimerResume,
                      onStop: _onTimerStop,
                      onFinish: _onTimerFinish,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
