import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_timer/models.dart';
import 'package:meditation_timer/services/settings_service.dart';
import 'package:meditation_timer/services/user_preferences_service.dart';
import 'package:meditation_timer/widgets/credits.dart';
import 'package:meditation_timer/widgets/selection_slider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _ready = false;
  List<BellSound> _bellSounds = [];
  BellSound? _selectedBellSound;
  bool _vibrateOnEndSetting = false;
  bool _reduceScreenBrightness = false;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _bellSounds = SettingsService.getBellSounds();
    _asyncInit();
  }

  @override
  dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _asyncInit() async {
    final bellSoundAsset = await UserPreferencesService.getEndBellSound();
    if (bellSoundAsset.isNotEmpty) {
      _selectedBellSound = _bellSounds.firstWhere((e) => e.asset == bellSoundAsset);
    }

    _vibrateOnEndSetting = await UserPreferencesService.getVibrateOnEnd();
    _reduceScreenBrightness = await UserPreferencesService.getReduceScreenBrightness();

    setState(() {
      _ready = true;
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  Future<void> _onSaveTap() async {
    await UserPreferencesService.setEndBellSound(_selectedBellSound != null ? _selectedBellSound!.asset : "");
    await UserPreferencesService.setVibrateOnEnd(_vibrateOnEndSetting);
    await UserPreferencesService.setReduceScreenBrightness(_reduceScreenBrightness);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _onVibrateOnEndChange(bool value) async {
    setState(() {
      _vibrateOnEndSetting = value;
    });
  }

  Future<void> _onBellSoundChange(final BellSound value) async {
    setState(() {
      _selectedBellSound = value;
    });

    if (_player.playing) {
      await _player.stop();
    }

    _player.setAsset(value.asset);
    await _player.play();
  }

  Future<void> _onReduceBrightnessChange(final bool value) async {
    setState(() {
      _reduceScreenBrightness = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !_ready
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Settings",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: SelectionSlider<BellSound>(
                        title: "End bell sound",
                        items: _bellSounds,
                        lightTheme: true,
                        titlePadding: 20,
                        defaultSelectedItem: _selectedBellSound,
                        onItemSelect: _onBellSoundChange,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vibrate on end",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Switch(
                              value: _vibrateOnEndSetting,
                              onChanged: _onVibrateOnEndChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Low screen brightness (reduce battery usage)",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 1.0),
                            ),
                            Switch(
                              value: _reduceScreenBrightness,
                              onChanged: _onReduceBrightnessChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _onCancelTap,
                              child: Text(AppLocalizations.of(context)!.generic_cancel),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: FilledButton(
                              onPressed: _onSaveTap,
                              child: Text(AppLocalizations.of(context)!.generic_save),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: const Credits(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
