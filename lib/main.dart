import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock/stock_bloc.dart';
import 'package:kasir_remake/bloc/transaction/transaction_bloc.dart';
import 'package:kasir_remake/insertbaru.dart';
import 'package:kasir_remake/msc/bloc_observer.dart';
import 'package:kasir_remake/page/debug.dart';
import 'package:kasir_remake/page/stats.dart';
import 'package:kasir_remake/transaksipage.dart';
import 'package:bloc/bloc.dart';
import 'package:kasir_remake/pulsa.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = NewBlocObserver();
  runApp(MyApp());
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
          primarySwatch: Colors.red,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int navIndex = 0;
  PageController pageC = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (i) {
              setState(() {
                navIndex = i;
              });
              pageC.animateToPage(i,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            currentIndex: navIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shop), label: 'Transaksi'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add New'),
              // BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add New'),
              BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Pulsa'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fire_extinguisher), label: 'debug'),
            ]),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  controller: pageC,
                  itemBuilder: (context, i) {
                    if (i == 0) return Stats();
                    if (i == 1) return TransaksiPage();
                    if (i == 2) return InsertProductPage();
                    if (i == 3) return TransaksiPulsa();
                    if (i == 4) return DebugPage();
                    return CircularProgressIndicator();
                  }),
            ),
          ],
        ));
  }
}
