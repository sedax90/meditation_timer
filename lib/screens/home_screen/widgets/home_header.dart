import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_timer/themes/app_theme.dart';
import 'package:meditation_timer/screens/settings_screen/settings.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  void _onSettingsTap(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const Wrap(
          children: [
            Settings(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Welcome back",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Bounceable(
                      onTap: () => _onSettingsTap(context),
                      child: SvgPicture.asset("assets/images/settings.svg"),
                    ),
                  ],
                ),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.1,
                    ),
                    children: [
                      TextSpan(
                        text: "Relax, your ",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "journey ",
                        style: TextStyle(
                          fontFamily: AppFonts.secondary,
                          fontSize: 36,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text: "begins ",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "here.",
                        style: TextStyle(
                          fontFamily: AppFonts.secondary,
                          fontSize: 36,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
