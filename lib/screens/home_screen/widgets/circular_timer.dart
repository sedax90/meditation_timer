import 'dart:async';
import 'dart:io';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_timer/screens/home_screen/widgets/circle_progress.dart';
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
  State<StatefulWidget> createState() => CircularTimerState();
}

class CircularTimerState extends State<CircularTimer> {
  int _seconds = 5;
  int _remainingSeconds = 5;
  Timer? _timer;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    super.dispose();
  }

  void setTime(final int timeSec) {
    setState(() {
      _seconds = timeSec;
      _remainingSeconds = timeSec;
    });
  }

  int getTimeSec() {
    return _seconds;
  }

  void _startTimer() {
    setState(() {
      _isActive = true;
    });

    if (_seconds == _remainingSeconds) {
      widget.onStart();
    } else {
      widget.onResume();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (_remainingSeconds == 0) {
        timer.cancel();
        await widget.onFinish();
        _resetTimer();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer!.cancel();
    widget.onPause();

    setState(() {
      _isActive = false;
    });
  }

  void _stopTimer() {
    _pauseTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.sand,
          content: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
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
                              _resetTimer();
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

  void _resetTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    setState(() {
      _isActive = false;
      _remainingSeconds = _seconds;
    });
  }

  void _openTimerSelection() {
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
                currentSeconds: _seconds,
                onTimeSet: (timeSec) {
                  setState(() {
                    _seconds = timeSec;
                    _remainingSeconds = timeSec;
                  });
                },
              ),
            ],
          );
        });
  }

  bool _timerIsRunning() {
    return _isActive || _remainingSeconds < _seconds;
  }

  Widget _buildRunningTimerControls() {
    final stopControl = GestureDetector(
      onTap: _stopTimer,
      child: SvgPicture.asset(
        "assets/images/stop.svg",
        height: 36,
      ),
    );

    if (_isActive) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          stopControl,
          const SizedBox(width: 25),
          GestureDetector(
            onTap: _pauseTimer,
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
            onTap: _startTimer,
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
    final percentage = (_remainingSeconds / _seconds) * 100;
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
                      color: Colors.black.withOpacity(0.5),
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
                    onTap: _openTimerSelection,
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 72, height: 1.0),
                        children: [
                          TextSpan(
                            text: TimerUtils.formatMinutes(_remainingSeconds),
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
                            text: TimerUtils.formatSeconds(_remainingSeconds),
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
                            onTap: _startTimer,
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
