class BackgroundSound {
  final String title;
  final String asset;

  BackgroundSound({required this.title, required this.asset});

  @override
  String toString() {
    return title;
  }
}

class Speed {
  final String title;
  final double value;

  Speed({required this.title, required this.value});

  @override
  String toString() {
    return title;
  }
}

class BellSound {
  final String title;
  final String asset;

  BellSound({required this.title, required this.asset});

  @override
  String toString() {
    return title;
  }
}

class Preset {
  final String title;
  final int timeSec;
  final String backgroundSound;
  final double speed;

  Preset({
    required this.title,
    required this.timeSec,
    required this.backgroundSound,
    required this.speed,
  });

  Preset.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        timeSec = json['timeSec'],
        backgroundSound = json['backgroundSound'],
        speed = json['speed'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'timeSec': timeSec,
      'backgroundSound': backgroundSound,
      'speed': speed,
    };
  }
}
