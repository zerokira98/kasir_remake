import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock/stock_bloc.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/bloc/transaction/transaction_bloc.dart';
import 'package:kasir_remake/insertbaru.dart';
import 'package:kasir_remake/msc/bloc_observer.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/page/debug.dart';
import 'package:kasir_remake/page/stats.dart';
import 'package:kasir_remake/transaksipage.dart';
import 'package:bloc/bloc.dart';
import 'package:kasir_remake/pulsa.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = NewBlocObserver();
  EquatableConfig.stringify = kDebugMode;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseRepository(DatabaseProvider.get),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TransactionBloc(
                RepositoryProvider.of<DatabaseRepository>(context)),
          ),
          BlocProvider(
            create: (context) =>
                StockBloc(RepositoryProvider.of<DatabaseRepository>(context)),
          ),
          BlocProvider(
            create: (context) => StockviewBloc(
                RepositoryProvider.of<DatabaseRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder()
            }),
            primarySwatch: Colors.red,
          ),
          home: HomePage(),
        ),
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
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'More'),
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
