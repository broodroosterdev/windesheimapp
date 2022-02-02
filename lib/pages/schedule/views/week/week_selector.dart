import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wind/pages/schedule/widgets/bottom_navigator.dart';

class WeekSelector extends StatefulWidget {
  final PageController pageController;
  final int page;
  final int maxPages;

  const WeekSelector({
    Key? key,
    required this.pageController,
    required this.page,
    required this.maxPages
  }) : super(key: key);

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.pageController,
      builder: (context, child) {
        return BottomNavigator(
          onBack: previousPage,
          onForward: nextPage,
          text: "Week ${widget.page + 1}/${widget.maxPages}",
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
