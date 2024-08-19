import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meditation_timer/themes/app_theme.dart';

class SavePresetForm extends StatefulWidget {
  final Function(String name) onPresetNameSubmit;

  const SavePresetForm({super.key, required this.onPresetNameSubmit});

  @override
  State<StatefulWidget> createState() => _SavePresetFormState();
}

class _SavePresetFormState extends State<SavePresetForm> {
  final _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      widget.onPresetNameSubmit(_nameController.text);
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty || value.length < 3) {
      return "Please enter a valid value";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Save preset", style: Theme.of(context).textTheme.titleLarge),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: TextFormField(
                  controller: _nameController,
                  validator: _validator,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.darkGreen),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    label: Text("Name"),
                  ),
                  autocorrect: false,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onCancel,
                      child: Text(AppLocalizations.of(context)!.generic_cancel),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: FilledButton(
                      onPressed: _onSave,
                      child: Text(AppLocalizations.of(context)!.generic_save),
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
