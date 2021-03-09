// import 'dart:ui';

import 'dart:io';

import 'package:flutter/material.dart';

class Mains extends StatefulWidget {
  @override
  _MainsState createState() => _MainsState();
}

class _MainsState extends State<Mains> with SingleTickerProviderStateMixin {
  // Alignment ali = Alignment(0, 0);
  double x = 0.0, y = 0.0;
  late Animation ani;
  late AnimationController acon;
  @override
  void initState() {
    super.initState();
    acon =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this)
          ..addListener(() {
            print(ani.value);
            print(acon.value);
          });
    ani =
        Tween<Offset>(begin: Offset(x, y), end: Offset(0.0, 0.0)).animate(acon);
  }

  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Center(
              child: GestureDetector(
        onTap: () async {
          await Future.delayed(Duration(milliseconds: 200));
        },
        onPanEnd: (details) {
          ani = Tween<Offset>(begin: Offset(x, y), end: Offset(0.0, 0.0))
              .animate(acon)
                ..addListener(() {
                  // print(ani.value);
                  setState(() {
                    this.x = ani.value.dx;
                    this.y = ani.value.dy;
                  });
                  // print();
                });
          acon.forward(from: 0.0);
        },
        onPanUpdate: (details) {
          // print(details.delta);
          double x = details.delta.dx;
          double y = details.delta.dy;
          setState(() {
            this.x += x;
            this.y += y;
          });
          // print('ali ${this.x}');
        },
        child: Transform.translate(
          offset: Offset(x, y),
          child: Container(
            // duration: Duration(milliseconds: 200),
            // color: Colors.blue,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              gradient: RadialGradient(colors: [
                Colors.white,
                Colors.white,
                Colors.grey,
              ]),
            ),
            padding: EdgeInsets.all(24),
            height: 100,
            child:
                // CircleAvatar(
                //   // backgroundImage:file?? FileImage(file??),
                // )
                Text('Drag me!'),
          ),
        ),
      ))),
    );
  }
}

class Mains1 extends StatelessWidget {
  final PageController pc = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        // transformAlignment: Alignment.topCenter,
        // transform: Matrix4.identity()..scale(0.9, 0.9),
        alignment: Alignment.bottomCenter,
        child: PageView.builder(
          controller: pc,
          itemBuilder: (context, i) {
            return PageA(pc: pc, index: i);
          },
          itemCount: 4,
          // children: [
          //   PageA(pc: pc),
          //   PageA(pc: pc),
          //   // PageB(pc: pc),
          // ],
        ),
      ),
    );
  }
}

class PageA extends StatefulWidget {
  final PageController? pc;
  final int? index;
  PageA({this.pc, int? index}) : this.index = index;

  @override
  _PageAState createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  PageController? pc;
  EdgeInsets margin = EdgeInsets.fromLTRB(0, 0, 0, 0);
  @override
  void dispose() {
    super.dispose();
  }

  void onChange() {
    // print(pc.offset);
    if (pc!.offset >= 423 * this.widget.index!) {
      margin = EdgeInsets.fromLTRB(18, 0, 18, 64);
    } else {
      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted) {}
        setState(() {
          margin = EdgeInsets.fromLTRB(0, 0, 0, 0);
        });
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    pc = this.widget.pc;
    pc!.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var maxoffset = 22 /
    //     7 *
    //     MediaQuery.of(context).size.width /
    //     (MediaQuery.of(context).size.width * 4);
    return AnimatedContainer(
      color: Colors.blue,
      margin: margin,
      duration: Duration(milliseconds: 100),
      alignment: Alignment.bottomCenter,
      // transformAlignment: Alignment.bottomCenter,
      transform: Matrix4.identity()
        ..rotateZ(-22 /
            7 *
            this.widget.pc!.offset /
            (MediaQuery.of(context).size.width * 4)),
      child: Center(
        child: Text('Page A ${this.widget.index}'),
      ),
    );
  }
}

class PageB extends StatefulWidget {
  final PageController? pc;
  PageB({this.pc});
  @override
  _PageBState createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  PageController? pc;
  EdgeInsets margin = EdgeInsets.fromLTRB(0, 0, 0, 0);

  @override
  void dispose() {
    super.dispose();
  }

  void onChange() {
    // print('0ffset = ${pc.offset}');
    // print('width = ${MediaQuery.of(context).size.width}');
    if (pc!.offset >= 423) {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          margin = EdgeInsets.fromLTRB(0, 0, 0, 0);
        });
      });
    } else {
      margin = EdgeInsets.fromLTRB(18, 0, 18, 64);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    pc = this.widget.pc;
    pc!.addListener(() {
      onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    var maxoffset = 22 /
        7 *
        MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.width * 4);
    var zVal = 22 /
        7 *
        this.widget.pc!.offset /
        (MediaQuery.of(context).size.width * 4);
    print(maxoffset);
    return AnimatedContainer(
      color: Colors.red,
      margin: margin,
      duration: Duration(milliseconds: 100),
      alignment: Alignment.bottomCenter,
      // transformAlignment: Alignment.bottomCenter,
      transform: Matrix4.identity()..rotateZ(maxoffset - zVal),
      child: Center(
        child: Text('Page B'),
      ),
    );
  }
}
