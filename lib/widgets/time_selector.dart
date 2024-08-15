import 'package:flutter/material.dart';
import 'package:meditation_timer/themes/app_theme.dart';

class TimeSelector extends StatefulWidget {
  final Function(int timeSec) onTimeSet;
  final int currentSeconds;

  const TimeSelector({
    super.key,
    required this.onTimeSet,
    this.currentSeconds = 420,
  });

  @override
  State<StatefulWidget> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  List<int> items = Iterable<int>.generate(90).toList()..removeRange(0, 5);
  int activePage = 0;
  final PageController _pageController = PageController(
    viewportFraction: 0.40,
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultValue = (widget.currentSeconds ~/ 60);
      final initialPage = items.indexWhere((e) {
        return e == defaultValue;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(initialPage);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSetTap() {
    Navigator.pop(context);
    widget.onTimeSet(items[activePage] * 60);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Set timer",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 110),
                      child: PageView.builder(
                          itemCount: items.length,
                          controller: _pageController,
                          physics: const PageScrollPhysics(),
                          onPageChanged: (page) {
                            setState(() {
                              activePage = page;
                            });
                          },
                          clipBehavior: Clip.none,
                          pageSnapping: true,
                          itemBuilder: (context, index) {
                            final current = index == activePage;

                            return AnimatedScale(
                              scale: current ? 1 : 0.5,
                              duration: const Duration(milliseconds: 200),
                              alignment: index < items.length
                                  ? (index < activePage ? Alignment.centerRight : Alignment.centerLeft)
                                  : Alignment.center,
                              child: AnimatedOpacity(
                                opacity: current ? 1 : 0.65,
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  items[index].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 96,
                                    height: 1.0,
                                    fontWeight: current ? FontWeight.normal : FontWeight.w100,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    const Text(
                      "Minutes",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: AppFonts.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _onCancelTap,
                              child: Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: FilledButton(
                              onPressed: _onSetTap,
                              child: Text("Set"),
                            ),
                          ),
                        ],
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
