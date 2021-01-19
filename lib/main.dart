import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock/stock_bloc.dart';
import 'package:kasir_remake/bloc/transaction/transaction_bloc.dart';
import 'package:kasir_remake/msc/db.dart';
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
    // print(bloc);
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
    // print(bloc);
    super.onTransition(bloc, transition);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionBloc(),
        ),
        BlocProvider(
          create: (context) => StockBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder()
          }),
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutt'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          // gridDelegate: ,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ElevatedButton(
              child: Text('form page'),
              onPressed: () {
                DBHelper.instance.insideTrans();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => FormInsert()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
