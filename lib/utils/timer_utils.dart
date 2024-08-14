class TimerUtils {
  static String formatMinutes(int seconds) {
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    return minutesStr;
  }

  static String formatSeconds(int seconds) {
    seconds = (seconds % 3600).truncate();
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return secondsStr;
  }
}
