import 'package:flutter/material.dart';
import 'package:wind/model/les.dart';
import 'package:wind/pages/schedule/views/day/day_element.dart';
import 'package:wind/pages/schedule/views/day/day_selector.dart';
import 'package:wind/utils/time.dart';

class DayView extends StatefulWidget {
  final List<Les>? lessen;
  final RefreshCallback onRefresh;

  DayView({
    Key? key,
    this.lessen,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  final PageController _pageController = PageController();

  int pageNumber = 0;

  DateTime get day {
    return DateTime.now().add(Duration(days: pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() => pageNumber = value);
            },
            itemBuilder: (BuildContext context, int index) {
              var d = DateTime.now().add(Duration(days: index));
              var lessen = widget.lessen
                  ?.where((les) => les.roosterdatum.isSameDate(d))
                  .toList();

              return RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: lessen != null
                      ? DayElement(
                    lessen: lessen,
                    day: d,
                    showDate: false,
                  )
                      : const Text("Loading"),
                ),
              );
            },
          ),
        ),
        DaySelector(
          pageController: _pageController,
          day: day,
        ),
      ],
    );
  }
}
