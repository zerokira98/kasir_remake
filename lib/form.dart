import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FormInsert extends StatefulWidget {
  @override
  _FormInsertState createState() => _FormInsertState();
}

class _FormInsertState extends State<FormInsert>
    with SingleTickerProviderStateMixin {
  TabController pc;
  PageController pageC;
  @override
  initState() {
    super.initState();
    pc = TabController(length: 3, vsync: this);
    pageC = PageController(initialPage: 0);
    pc.addListener(() {
      pageC.animateToPage(pc.index,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
      // setState(() {});
      print(pc.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(padding: EdgeInsets.all(18.0), child: TabCustom(pc: pc)),
          Expanded(
            child: PageView.builder(
                itemCount: 3,
                controller: pageC,
                itemBuilder: (context, i) {
                  if (i == 0) return RealForm();
                  return Center(
                    child: Text('page $i'),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class TabCustom extends StatefulWidget {
  final TabController pc;
  TabCustom({this.pc});
  @override
  _TabCustomState createState() => _TabCustomState();
}

class _TabCustomState extends State<TabCustom> {
  TabController pc;

  int selectedIndex = 0;
  var selectedsizewidth = 0.0;

  @override
  void initState() {
    pc = this.widget.pc;

    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      RenderBox a = context.findRenderObject();
      print(a.size.width / 3);
      setState(() {
        selectedsizewidth = a.size.width / 3;
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
            height: 70,
            padding: EdgeInsets.symmetric(vertical: 12.0),
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
                  left: selectedIndex == 0
                      ? 0
                      : selectedIndex == 1
                          ? selectedsizewidth
                          : selectedsizewidth * 2,
                  child: AnimatedContainer(
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 500),
                      width: selectedsizewidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue)),
                ),
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          elevation: 0,
                          child: Text('Tab 1',
                              style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Colors.white
                                      : Colors.black)),
                          onPressed: () {
                            pc.index = 0;
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          child: Text('Tab 2',
                              style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black)),
                          onPressed: () {
                            pc.index = 1;
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          child: Text('Tab 3',
                              style: TextStyle(
                                  color: selectedIndex == 2
                                      ? Colors.white
                                      : Colors.black)),
                          onPressed: () {
                            pc.index = 2;
                            setState(() {
                              selectedIndex = 2;
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}

class RealForm extends StatefulWidget {
  @override
  _RealFormState createState() => _RealFormState();
}

class _RealFormState extends State<RealForm> {
  GlobalKey keys;
  SuggestionsBoxController sbc;
  TextEditingController tec;

  @override
  void initState() {
    super.initState();
    keys = GlobalKey();
    sbc = SuggestionsBoxController();
    tec = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TypeAheadField(
                suggestionsBoxController: sbc,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: tec,
                    // autofocus: true,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontStyle: FontStyle.italic),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Nama item')),
                suggestionsCallback: (pattern) async {
                  // return [
                  //   {"name": "nama", "price": 400}
                  // ];
                  // return await BackendService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text(suggestion['name']),
                    subtitle: Text('\$${suggestion['price']}'),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // tec.text = suggestion['name'];
                },
              ),
            ),
          ],
        ));
  }
}
