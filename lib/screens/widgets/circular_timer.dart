import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_timer/screens/widgets/circle_progress.dart';
import 'package:meditation_timer/themes/app_theme.dart';
import 'package:meditation_timer/utils/timer_utils.dart';
import 'package:meditation_timer/widgets/time_selector.dart';

class CircularTimer extends StatefulWidget {
  final Function() onFinish;

  const CircularTimer({
    super.key,
    required this.onFinish,
  });

  @override
  State<StatefulWidget> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  int seconds = 1;
  int remainingSeconds = 1;
  Timer? timer;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    super.dispose();
  }

  void startTimer() {
    setState(() {
      isActive = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        widget.onFinish();
        resetTimer();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void pauseTimer() {
    timer!.cancel();

    setState(() {
      isActive = false;
    });
  }

  void resetTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    setState(() {
      isActive = false;
      remainingSeconds = seconds;
    });
  }

  void openTimerSelection() {
    if (_timerIsRunning()) {
      return;
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Wrap(
            children: [
              TimeSelector(
                currentSeconds: seconds,
                onTimeSet: (timeSec) {
                  setState(() {
                    seconds = timeSec;
                    remainingSeconds = timeSec;
                  });
                },
              ),
            ],
          );
        });
  }

  bool _timerIsRunning() {
    return isActive || remainingSeconds < seconds;
  }

  Widget _buildRunningTimerControls() {
    final stopControl = GestureDetector(
      onTap: resetTimer,
      child: SvgPicture.asset(
        "assets/images/stop.svg",
        height: 36,
      ),
    );

    if (isActive) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          stopControl,
          const SizedBox(width: 25),
          GestureDetector(
            onTap: pauseTimer,
            child: SvgPicture.asset(
              "assets/images/pause.svg",
              height: 36,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          stopControl,
          const SizedBox(width: 25),
          GestureDetector(
            onTap: startTimer,
            child: SvgPicture.asset(
              "assets/images/play.svg",
              height: 36,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (remainingSeconds / seconds) * 100;
    final radian = percentage * 0.01 * 2 * pi;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.all(
              Radius.circular(600),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: CircleProgress(
                  value: radian,
                  color: AppColors.lightGreen,
                  strokeWidth: 1,
                  width: MediaQuery.of(context).size.width * 0.60,
                ),
              ),
              DefaultTextStyle.merge(
                style: const TextStyle(
                  color: AppColors.lightGreen,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Time left",
                      style: TextStyle(
                        fontFamily: AppFonts.secondary,
                        color: AppColors.green,
                        fontSize: 20,
                        height: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: openTimerSelection,
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 72, height: 1.0),
                          children: [
                            TextSpan(
                              text: TimerUtils.formatMinutes(remainingSeconds),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: ":",
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            TextSpan(
                              text: TimerUtils.formatSeconds(remainingSeconds),
                              style: const TextStyle(
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: _timerIsRunning()
                          ? _buildRunningTimerControls()
                          : GestureDetector(
                              onTap: startTimer,
                              child: SvgPicture.asset(
                                "assets/images/play.svg",
                                height: 36,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
