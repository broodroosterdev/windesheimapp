import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wind/pages/schedule/widgets/bottom_navigator.dart';
import 'package:wind/utils/time.dart';

class DaySelector extends StatefulWidget {
  final PageController pageController;
  final DateTime day;

  const DaySelector({
    Key? key,
    required this.pageController,
    required this.day,
  }) : super(key: key);

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.pageController,
      builder: (context, child) {
        return BottomNavigator(
          onBack: previousPage,
          onForward: nextPage,
          text: widget.day.toDateString(),
        );
      },
    );
  }

  void previousPage() {
    widget.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void nextPage() {
    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}
