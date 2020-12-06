import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FormInsert extends StatefulWidget {
  @override
  _FormInsertState createState() => _FormInsertState();
}

class _FormInsertState extends State<FormInsert> {
  PageController pageC = PageController(initialPage: 0);
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: EdgeInsets.all(18.0),
              child: TabCustom(
                  pageController: pageC,
                  length: 1,
                  items: ['Main menu', 'Profile', 'DM'])),
          Expanded(
            child: PageView.builder(
                itemCount: 5,
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
  final PageController pageController;
  final int length;
  final List items;
  TabCustom({@required this.pageController, this.length, List items})
      : this.items = items;

  @override
  _TabCustomState createState() => _TabCustomState();
}

class _TabCustomState extends State<TabCustom>
    with SingleTickerProviderStateMixin {
  TabController pc;
  List items;
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
  TextEditingController harga = TextEditingController();

  @override
  void initState() {
    harga.text = '5000';

    keys = GlobalKey();
    sbc = SuggestionsBoxController();
    tec = TextEditingController();
    super.initState();
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
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: harga,
                    decoration: InputDecoration(labelText: 'Harga per pcs'),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(),
                )),
              ],
            )
          ],
        ));
  }
}
