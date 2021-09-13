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

  List<Les>? get lessen {
    return widget.lessen
        ?.where((les) => les.roosterdatum.isSameDate(day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.custom(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() => pageNumber = value);
            },
            childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return RefreshIndicator(
                  onRefresh: widget.onRefresh,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: lessen != null
                        ? DayElement(
                            lessen: lessen!,
                            day: day,
                            showDate: false,
                          )
                        : const Text("Loading"),
                  ),
                );
              },
            ),
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
