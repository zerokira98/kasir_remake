import 'package:flutter/material.dart';
import 'package:kasir_remake/db.dart';
import 'package:kasir_remake/form.dart';
import 'package:kasir_remake/protopage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    var dbase = DBHelper.instance.showTables();

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: Text('press close'),
              onPressed: () {
                DBHelper.instance.closeDb();
              },
            ),
            ElevatedButton(
              child: Text('press inside items'),
              onPressed: () {
                DBHelper.instance.showInside();
              },
            ),
            ElevatedButton(
              child: Text('test'),
              onPressed: () {
                DBHelper.instance.test();
              },
            ),
            ElevatedButton(
              child: Text('form page'),
              onPressed: () {
                // DBHelper.instance.test();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FormInsert()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
