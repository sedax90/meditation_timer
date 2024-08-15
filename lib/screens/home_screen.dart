import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_timer/screens/widgets/circular_timer.dart';
import 'package:meditation_timer/screens/widgets/home_header.dart';
import 'package:meditation_timer/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AudioPlayer player;

  @override
  initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  dispose() async {
    super.dispose();

    if (player.playing) {
      player.stop();
    }
    await player.dispose();
  }

  Future<void> _onTimerFinish() async {
    await player.setAsset("assets/audio/bells/bell-1.mp3");
    await player.setLoopMode(LoopMode.off);
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: const HomeHeader(),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, MediaQuery.of(context).size.width * 0.45),
                    child: Container(
                      height: 1000,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(54, 131, 104, 1),
                            Color.fromRGBO(12, 29, 23, 1),
                          ],
                          stops: [0, 0.75],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CircularTimer(
                      onFinish: _onTimerFinish,
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
