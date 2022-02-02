import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/views/week/week_element.dart';
import 'package:wind/pages/schedule/views/week/week_selector.dart';

class WeekView extends StatefulWidget {
  final List<Les>? lessen;
  final RefreshCallback onRefresh;

  const WeekView({
    Key? key,
    this.lessen,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  static const maxPages = 10;

  final PageController _pageController = PageController();

  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: maxPages,
            controller: _pageController,
            onPageChanged: (value) {
              setState(() => pageNumber = value);
            },
            itemBuilder: (BuildContext context, int index) {
              return RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: widget.lessen != null
                      ? WeekElement(lessen: widget.lessen!, weekNumber: index)
                      : const Text("Loading"),
                ),
              );
            },
          ),
        ),
        WeekSelector(
          pageController: _pageController,
          page: pageNumber,
          maxPages: maxPages,
        ),
      ],
    );
  }
}
