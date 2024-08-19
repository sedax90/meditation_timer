import 'package:flutter/material.dart';
import 'package:meditation_timer/models.dart';
import 'package:meditation_timer/services/user_preferences_service.dart';
import 'package:meditation_timer/themes/app_theme.dart';

class Presets extends StatefulWidget {
  final Function(Preset preset) onPresetSelect;

  const Presets({super.key, required this.onPresetSelect});

  @override
  State<StatefulWidget> createState() => _PresetsState();
}

class _PresetsState extends State<Presets> {
  List<Preset> _presets = [];

  @override
  void initState() {
    super.initState();

    _asyncInit();
  }

  Future<void> _asyncInit() async {
    _presets = await UserPreferencesService.getPresets();
    setState(() {});
  }

  void _onPresetTap(final Preset preset) {
    widget.onPresetSelect(preset);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Presets",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _presets.isEmpty
                  ? Text("No presets")
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: _presets.map((e) {
                            return Container(
                              margin: const EdgeInsets.only(right: 10, bottom: 8),
                              child: GestureDetector(
                                onTap: () => _onPresetTap(e),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.darkGreen),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    e.name,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
