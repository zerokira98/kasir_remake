import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/listviewof_item.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kasir_remake/page/stockview.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('misc'),
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
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Print Monthly Stock'),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Alert'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              var a = await getApplicationDocumentsDirectory();
                              File theFile = File(a.path);
                              var b = ListToCsvConverter().convert([
                                ['Nama', 'Umur', 'Sex'],
                                ['Rizal', '21', 'Male'],
                              ]);
                              theFile.writeAsStringSync(b);
                            },
                            child: Text('Print March'))
                      ],
                    );
                  });
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
