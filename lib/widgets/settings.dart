import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Settings"),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
