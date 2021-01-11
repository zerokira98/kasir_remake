import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/transaction_bloc.dart';
import 'package:kasir_remake/db.dart';
import 'package:kasir_remake/form.dart';
import 'package:kasir_remake/protopage.dart';
import 'package:bloc/bloc.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = NewBlocObserver();
  runApp(MyApp());
}

class NewBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    print(bloc);
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    print(error);
    super.onError(cubit, error, stacktrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    print(bloc);
    super.onTransition(bloc, transition);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
                DBHelper.instance.showInsideItems();
              },
            ),
            ElevatedButton(
              child: Text('press inside add_stock'),
              onPressed: () {
                DBHelper.instance.showInsideStock();
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
