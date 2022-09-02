import 'package:flutter/material.dart';
import 'package:hangeureut/constants.dart';
import 'package:hangeureut/providers/filter/filter_state.dart';
import 'package:hangeureut/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../../models/search_model.dart';
import '../../providers/filter/filter_provider.dart';
import '../basic_screen/basic_screen_page.dart';

class SearchingPage extends StatelessWidget {
  const SearchingPage({Key? key}) : super(key: key);
  static const String routeName = "/searching";

  @override
  Widget build(BuildContext context) {
    final currentState = context.watch<SearchFilterState>();
    final mainFilter = currentState.filter.mainFilter;
    List subOptions = filterMap[mainFilter].keys.toList();
    return Scaffold(
      backgroundColor: kBackgroundColor2,
      bottomNavigationBar: BasicBottomNavigationBar(
        option1: "이전",
        option2: "바로 찾기",
        nav1: BasicScreenPage.routeName,
        nav2: BasicScreenPage.routeName,
        // 메인 페이지로 돌아가면서 현재 페이지가 무엇인지 provider로 저장, 메인페이지는 해당 값을 반영해서 페이지 띄움
        // 서치 결과의 경우 메인페이지의 새로운 인덱스로 들어가는 것이 좋을듯(4번)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: ListView(padding: EdgeInsets.zero, children: [
          SizedBox(
            height: 100,
          ),
          Text(
            "이런 음식 원해요!",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              mainFilterButton(context, MainFilter.meal),
              mainFilterButton(context, MainFilter.alcohol),
              mainFilterButton(context, MainFilter.coffee)
            ],
          ),
          SizedBox(
            height: 50,
            child: Divider(
              color: Color(0xff8B867D),
            ),
          ),
          Text(
            "이런 느낌 원해요!",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubFilterButton(
                      mainFilter: mainFilter, subFilter: subOptions[1]),
                  SubFilterButton(
                      mainFilter: mainFilter, subFilter: subOptions[2]),
                  SubFilterButton(
                      mainFilter: mainFilter, subFilter: subOptions[3]),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubFilterButton(
                      mainFilter: mainFilter, subFilter: subOptions[4]),
                  SubFilterButton(
                      mainFilter: mainFilter, subFilter: subOptions[5]),
                  SubFilterButton(
                      mainFilter: mainFilter, subFilter: subOptions[6]),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 130,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "위치 선택하기 >",
                style: TextStyle(fontSize: 14, color: kThirdColor),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

class SubFilterButton extends StatefulWidget {
  const SubFilterButton(
      {Key? key, required this.mainFilter, required this.subFilter})
      : super(key: key);
  final mainFilter;
  final subFilter;

  @override
  State<SubFilterButton> createState() => _SubFilterButtonState();
}

class _SubFilterButtonState extends State<SubFilterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          context.read<SearchFilterProvider>().addSubFilter(widget.subFilter);
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: subButtonColor(context, widget.subFilter),
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 30,
                child: Image.asset(
                    filterMap[widget.mainFilter][widget.subFilter][0])),
            Positioned(
                top: 65,
                child: Text(
                  filterMap[widget.mainFilter][widget.subFilter][1],
                  style: TextStyle(fontSize: 12),
                )),
          ],
        ),
      ),
    );
  }
}

Color subButtonColor(BuildContext context, subFilter) {
  final state = context.watch<SearchFilterState>();
  List subFilters = state.filter.subFilterList;
  print(subFilters.contains(subFilter));

  return subFilters.contains(subFilter) ? Colors.white : kBackgroundColor2;
}

Widget mainFilterButton(BuildContext context, MainFilter filter) {
  return GestureDetector(
    onTap: () {
      context
          .read<SearchFilterProvider>()
          .changeFilter(Filter(mainFilter: filter));
    },
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: mainButtonColor(context, filter),
        borderRadius: BorderRadius.all(
          Radius.circular(22),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 30, child: Image.asset(filterMap[filter][filter][0])),
          Positioned(
              top: 65,
              child: Text(
                filterMap[filter][filter][1],
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    ),
  );
}

Color mainButtonColor(BuildContext context, MainFilter filter) {
  final currentMainFilter =
      context.watch<SearchFilterState>().filter.mainFilter;
  return currentMainFilter == filter ? Colors.white : kBackgroundColor2;
}
