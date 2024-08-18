import 'package:flutter/widgets.dart';

class Credits extends StatelessWidget {
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Madre with ♥️ by Cristian Sedaboni",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12),
    );
  }
}
