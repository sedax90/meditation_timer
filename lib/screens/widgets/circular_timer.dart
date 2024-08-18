import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_timer/screens/widgets/circle_progress.dart';
import 'package:meditation_timer/themes/app_theme.dart';
import 'package:meditation_timer/utils/timer_utils.dart';
import 'package:meditation_timer/widgets/time_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CircularTimer extends StatefulWidget {
  final Function() onStart;
  final Function() onPause;
  final Function() onResume;
  final Function() onStop;
  final Future<void> Function() onFinish;

  const CircularTimer({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    required this.onFinish,
  });

  @override
  State<StatefulWidget> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  int seconds = 5;
  int remainingSeconds = 5;
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

    if (seconds == remainingSeconds) {
      widget.onStart();
    } else {
      widget.onResume();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (remainingSeconds == 0) {
        timer.cancel();
        await widget.onFinish();
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
    widget.onPause();

    setState(() {
      isActive = false;
    });
  }

  void stopTimer() {
    pauseTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.sand,
          title: Text("Confirm"),
          content: Wrap(
            children: [
              Column(
                children: [
                  Text("Are you shure?"),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(AppLocalizations.of(context)!.generic_cancel),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onStop();
                              resetTimer();
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(AppLocalizations.of(context)!.generic_confirm),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
      onTap: stopTimer,
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: 110,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.65),
                      blurRadius: 30,
                      spreadRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.all(
                  Radius.circular(600),
                ),
              ),
            ),
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
    );
  }
}
