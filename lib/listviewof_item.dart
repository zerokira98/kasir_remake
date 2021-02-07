import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:kasir_remake/msc/db.dart';

import 'package:intl/intl.dart';

final numFormat = new NumberFormat("#,##0.00", "en_US");

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
              child: BlocBuilder<StockviewBloc, StockviewState>(
                  builder: (context, state) {
                if (state is StockviewLoaded) {
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      ItemTr data = state.data[i];
                      var hargaBeli = numFormat.format(data.hargaBeli);
                      var hargaJual = numFormat.format(data.hargaJual);
                      var totalBeli =
                          numFormat.format(data.pcs * data.hargaBeli);
                      return Container(
                        margin: EdgeInsets.only(bottom: 8, left: 4, right: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          isThreeLine: true,
                          // shape: RoundedRectangleBorder( ),
                          // tileColor: Colors.white,
                          title: Text(state.data[i].name.toString()),
                          subtitle: Row(
                            children: [
                              Text('Tempat beli: ${data.tempatBeli}' +
                                  '\nTanggal beli : ${data.ditambahkan.toString().substring(0, 10)}' +
                                  '\nJumlah item : ${data.pcs}pcs'),
                              Expanded(
                                child: Container(),
                              ),
                              Text(
                                  'Harga jual : $hargaJual \nHarga beli : $hargaBeli' +
                                      '\nTotal beli : $totalBeli')
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.data.length,
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
  var dateFrom = TextEditingController();
  var dateTo = TextEditingController();
  var dateFromFull, dateToFull;
  var namaBarang = TextEditingController();
  final int dropdownValue = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockviewBloc, StockviewState>(
      builder: (context, state) {
        if (state is StockviewLoaded) {
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
                border: Border.all(color: Colors.grey[50]),
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: namaBarang,
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
                      child:
                          // InputDatePickerFormField(
                          //     firstDate: DateTime.now(), lastDate: DateTime.now()),
                          InkWell(
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          dateFrom.text =
                              selectedDate.toString().substring(0, 10);
                          dateFromFull = selectedDate.toString();
                        },
                        child: TextField(
                          enabled: false,
                          controller: dateFrom,
                          decoration: InputDecoration(labelText: 'From'),
                        ),
                      ),
                    ),
                    Text(' - '),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          dateTo.text =
                              selectedDate.toString().substring(0, 10);
                          dateToFull = selectedDate.toString();
                        },
                        child: TextField(
                          controller: dateTo,
                          enabled: false,
                          decoration: InputDecoration(labelText: 'To'),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('Sort by:'),
                    DropdownButton(
                        value: dropdownValue,
                        items: [
                          DropdownMenuItem(
                            child: Text('Nama A->Z'),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Text('Nama Z->A'),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text('Tanggal Ascending'),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text('Tanggal Descending'),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text('Tempat Beli A->Z'),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text('Tempat Beli Z->A'),
                            value: 5,
                          ),
                        ],
                        onChanged: (v) {
                          // dropdownValue = v;
                        }),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          // print(namaBarang.text + dateFromFull + dateToFull);
                          BlocProvider.of<StockviewBloc>(context)
                              .add(FilterChange(
                            name: namaBarang.text ?? '',
                            dateStart: dateFromFull,
                            dateEnd: dateToFull,
                          ));
                        },
                        child: Text('Go'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
