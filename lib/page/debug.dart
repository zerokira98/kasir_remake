import 'package:flutter/material.dart';
import 'package:kasir_remake/listviewof_item.dart';
import 'package:kasir_remake/msc/db.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug page'),
      ),
      body: SafeArea(
        child: GridView.count(
          padding: EdgeInsets.all(8.0),
          crossAxisCount: 3,
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
              child: Text('show tables'),
              onPressed: () {
                DBHelper.instance.showTables();
              },
            ),
            ElevatedButton(
              child: Text('Test go list of items'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListOfItems()));
                // DBHelper.instance.test();
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
            ElevatedButton(
              child: Text('Stock History'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListOfStockItems()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
