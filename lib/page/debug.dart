import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/listviewof_item.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kasir_remake/page/stockview/stockview.dart';

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
                    return PrintAlert();
                  });
            },
          ),
          ElevatedButton(
            child: Text('Test terminal'),
            onPressed: () async {
              // Map a = {
              //   'abc': {
              //     'def': {'def1', 'def2', 'def3'},
              //     'ghi': {'ghi1', 'ghi2'}
              //   }
              // };
              // for (var b in a['abc'].values) {
              //   print(b);
              // }
              // a['abc'].forEach((key, value) {
              //   print('key :' + key);
              //   print('value :' + value.toString());
              // });
              var wao =
                  (await RepositoryProvider.of<DatabaseRepository>(context)
                      .showInsideStock(page: 0, showName: true));
              print(wao);
              print(wao['maxEntry']);
              // print(DateTime.now());
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ListOfStockItems()));
            },
          ),
        ],
      ),
    );
  }
}

class PrintAlert extends StatefulWidget {
  @override
  _PrintAlertState createState() => _PrintAlertState();
}

class _PrintAlertState extends State<PrintAlert> {
  List data = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  var multivalue = 0;
  @override
  void initState() {
    multivalue = DateTime.now().month - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Print'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Month'),
              Padding(padding: EdgeInsets.all(16.0)),
              Expanded(
                child: DropdownButton<int>(
                  onChanged: (val) {
                    setState(() {
                      multivalue = val!;
                    });
                  },
                  items: [
                    for (int i = 0; i < 12; i++)
                      DropdownMenuItem(
                        child: Text(data[i].toString()),
                        value: i,
                        // onTap: () {},
                      ),
                  ],
                  value: multivalue,
                ),
              ),
            ],
          ),
          // CupertinoDatePicker(onDateTimeChanged: (val){},,)
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Directory? a = await getExternalStorageDirectory();
              String month = multivalue.toString().length == 1
                  ? '0' + (multivalue + 1).toString()
                  : (multivalue + 1).toString();
              var data = await RepositoryProvider.of<DatabaseRepository>(
                      context)
                  .showInsideStock(
                      page: -1,
                      showName: true,
                      startDate: DateTime.parse(DateTime.now().year.toString() +
                              '-$month-' +
                              '01')
                          .toString(),
                      endDate: DateTime.parse((DateTime.now().year).toString() +
                              '-' +
                              month +
                              '-' +
                              DateTime(DateTime.now().year, multivalue + 2, 0)
                                  .day
                                  .toString())
                          .toString());
              print(data);
              print(a!.path);
              if (data['res'].isNotEmpty) {
                File theFile = File(a.path + '/backup.csv');
                double totalkeluar = 0.0;
                var datalist = (data['res'] as List)
                    .map<List>((e) => [
                          e['ADD_DATE'],
                          // ?.toString().substring(0, 10),
                          e['NAMA'],
                          e['PRICE'],
                          e['QTY'],
                          e['SUPPLIER']
                        ])
                    .toList();
                for (var item in datalist) {
                  totalkeluar += item[2] * item[3];
                }
                datalist[0]
                  ..add('')
                  ..add('Total bulan ini : ')
                  ..add(totalkeluar);
                var b = ListToCsvConverter().convert(datalist);
                try {
                  await theFile.writeAsString(b, mode: FileMode.write);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Successfully printed'),
                  ));
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('error'),
                        );
                      });
                }
                print('end');
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('No data on selected month'),
                      );
                    });
              }
            },
            child: Text('Print'))
      ],
    );
  }
}
