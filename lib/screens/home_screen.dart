import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_timer/models.dart';
import 'package:meditation_timer/screens/widgets/circular_timer.dart';
import 'package:meditation_timer/screens/widgets/home_header.dart';
import 'package:meditation_timer/services/settings_service.dart';
import 'package:meditation_timer/themes/app_theme.dart';
import 'package:meditation_timer/widgets/selection_slider.dart';
import 'package:vibration/vibration.dart';

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
      final hasVibration = await Vibration.hasVibrator();
      if (hasVibration == true) {
        Vibration.vibrate(duration: 800);
      }

      await player.setAsset("assets/audio/bells/bell-1.mp3");
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
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
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
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: SelectionSlider<BackgroundSound>(
                              title: "Background sound",
                              items: _backgroundSounds,
                              selectedItem: _selectedBackgroundSound,
                              onItemSelect: _onBackgroundSelect,
                              disabled: _timerActive,
                            ),
                          ),
                          SelectionSlider<Speed>(
                            title: "Speed",
                            items: _speeds,
                            selectedItem: _selectedSpeed,
                            onItemSelect: _onSpeedSelect,
                            disabled: _timerActive,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CircularTimer(
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
