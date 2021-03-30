import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/listviewof_item.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/page/stockview.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug page'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),

        // crossAxisCount: 1,
        // gridDelegate: ,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // AnimatedOpacity(
          //   opacity: 0.5,
          //   duration: Duration(milliseconds: 300),
          //   curve: Curves.bounceIn,
          //   child: ElevatedButton(
          //     child: Text('transactions'),
          //     onPressed: () {
          //       RepositoryProvider.of<DatabaseRepository>(context)
          //           .insideTrans();
          //     },
          //   ),
          // ),
          // ElevatedButton(
          //   child: Text('press inside items'),
          //   onPressed: () {
          //     RepositoryProvider.of<DatabaseRepository>(context)
          //         .showInsideItems();
          //   },
          // ),
          // ElevatedButton(
          //   child: Text('press inside add_stock'),
          //   onPressed: () {
          //     RepositoryProvider.of<DatabaseRepository>(context)
          //         .showInsideStock(showName: true);
          //   },
          // ),
          // ElevatedButton(
          //   child: Text('close database'),
          //   onPressed: () {
          //     RepositoryProvider.of<DatabaseRepository>(context).closeDb();
          //   },
          // ),
          // ElevatedButton(
          //   child: Text('show tables'),
          //   onPressed: () {
          //     RepositoryProvider.of<DatabaseRepository>(context).showTables();
          //   },
          // ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Test go list of items'),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListOfItems()));
              // RepositoryProvider.of<DBHelper>(context).test();
              // List numb = [1, 2, 3, 4];
              // var numb2 = numb;
              // numb2.removeLast();
              // List<Map<String, dynamic>> a = [
              //   {
              //     'nama': 'nick',
              //     'umur': 22,
              //   },
              //   {
              //     'nama': 'rick',
              //     'umur': 24,
              //   },
              // ];
              // var b = a[0];
              // b.remove('umur');
              // print(numb);
              // print(numb2);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => FormInsert()));
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Stock History'),
            ),
            onPressed: () {
              BlocProvider.of<StockviewBloc>(context).add(Initializeview());
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListOfStockItems()));
            },
          ),
          // ElevatedButton(
          //   child: Text('Test terminal'),
          //   onPressed: () {
          //     Map a = {
          //       'abc': {
          //         'def': {'def1', 'def2', 'def3'},
          //         'ghi': {'ghi1', 'ghi2'}
          //       }
          //     };
          //     for (var b in a['abc'].values) {
          //       print(b);
          //     }
          //     // a['abc'].forEach((key, value) {
          //     //   print('key :' + key);
          //     //   print('value :' + value.toString());
          //     // });
          //     // RepositoryProvider.of<DBHelper>(context).showPlaces();
          //     // print(DateTime.now());
          //     // Navigator.push(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //         builder: (context) => ListOfStockItems()));
          //   },
          // ),
        ],
      ),
    );
  }
}
