import 'package:flutter/material.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:kasir_remake/msc/db.dart';

class ListOfItems extends StatefulWidget {
  @override
  _ListOfItemsState createState() => _ListOfItemsState();
}

class _ListOfItemsState extends State<ListOfItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Registered Items'),
      ),
      body: FutureBuilder<List>(
          future: DBHelper.instance.showInsideItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return ListView.builder(
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(snapshot.data[i]['NAMA']),
                    subtitle: Text('Harga : ${snapshot.data[i]['HARGA_JUAL']}'),
                  );
                },
                itemCount: snapshot.data.length,
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class ListOfStockItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori tambah stock'),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            FilterBox(),
            Expanded(
              child: FutureBuilder<List>(
                  future: DBHelper.instance.showInsideStock(null, true),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return ListView.builder(
                        itemBuilder: (context, i) {
                          var a = DateTime.parse(
                                  snapshot.data[i]['ADD_DATE'].toString() + 'Z')
                              .toLocal();
                          var data = snapshot.data[i];
                          return ListTile(
                            title: Text(snapshot.data[i]['NAMA'].toString()),
                            subtitle: Row(
                              children: [
                                Text('Tanggal beli : ${a.toString().substring(0, 19)}' +
                                    '\nTempat beli: ${snapshot.data[i]['SUPPLIER']}'),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                    'Harga beli : ${data['PRICE']}\nHarga jual : ${data['HARGA_JUAL']}')
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    }
                    return CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.all(18.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.grey,
              offset: Offset(8.0, 8.0),
            ),
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.white,
              offset: Offset(-8.0, -8.0),
            )
          ],
          // border: Border.all(),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    labelText: 'Nama barang',
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    labelText: 'Tempat beli',
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Tanggal : '),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'From'),
                ),
              ),
              Text(' - '),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'To'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Sort by:'),
              RaisedButton(
                onPressed: () {},
                child: Text('Go'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
