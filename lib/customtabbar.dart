import 'package:flutter/scheduler.dart';

import 'package:flutter/material.dart';

class TabCustom extends StatefulWidget {
  final PageController pageController;
  final int length;
  final List items;
  TabCustom({@required this.pageController, this.length, List<String> items})
      : this.items = items;

  @override
  _TabCustomState createState() => _TabCustomState();
}

class _TabCustomState extends State<TabCustom>
    with SingleTickerProviderStateMixin {
  TabController pc;
  List<String> items;
  PageController pageController;
  int selectedIndex = 0, length;
  double selectedsizewidth = 0.0;

  @override
  void initState() {
    items = this.widget.items;
    length = items.length ?? this.widget.length;
    pageController = this.widget.pageController;
    pc = TabController(length: length, vsync: this);
    pc.addListener(() {
      pageController.animateToPage(pc.index,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox a = context.findRenderObject();
      setState(() {
        selectedsizewidth = a.size.width / length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            // height: 70,
            // padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100]),
                  height: 42,
                ),
                AnimatedPositioned(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 500),
                  top: 2,
                  bottom: 2,
                  left: selectedIndex * selectedsizewidth,
                  child: Container(
                      // curve: Curves.ease,
                      // duration: Duration(milliseconds: 500),
                      width: selectedsizewidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue)),
                ),
                Positioned.fill(
                  child: Row(
                    children: [
                      for (int i = 0; i < length; i++)
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            child: Text(items[i] ?? 'Tab $i',
                                style: TextStyle(
                                    color: selectedIndex == i
                                        ? Colors.white
                                        : Colors.black)),
                            onPressed: () {
                              pc.index = i;
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
