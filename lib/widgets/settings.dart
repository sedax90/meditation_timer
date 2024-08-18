import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meditation_timer/models.dart';
import 'package:meditation_timer/services/settings_service.dart';
import 'package:meditation_timer/widgets/credits.dart';
import 'package:meditation_timer/widgets/selection_slider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<BellSound> _bellSounds = [];

  @override
  void initState() {
    super.initState();

    _bellSounds = SettingsService.getBellSounds();
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  Future<void> _onSaveTap() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
                child: SelectionSlider(
                  title: "End bell sound",
                  items: _bellSounds,
                  lightTheme: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: SelectionSlider(
                  title: "Vibrate on end",
                  items: [],
                  lightTheme: true,
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
