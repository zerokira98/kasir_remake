import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/model/item_tr.dart';

final numFormat = new NumberFormat("#,##0.00", "en_US");

class ListOfStockItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori tambah stock'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                BlocProvider.of<StockviewBloc>(context).add(Initializeview());
              }),
          Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  // BlocProvider.of<StockviewBloc>(context).add(Initializeview());
                  Scaffold.of(context).showBottomSheet(
                      (context) => Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Container(color: Colors.transparent)),
                              ),
                              FilterBox(),
                            ],
                          ),
                      backgroundColor: Colors.black26);
                }),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            // FilterBox(),
            Expanded(
              child: BlocBuilder<StockviewBloc, StockviewState>(
                  builder: (context, state) {
                if (state is StockviewLoaded) {
                  if (state.data.isEmpty) {
                    return Center(child: Text('Empty!'));
                  }
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      ItemTr data = state.data[i];

                      return Column(
                        children: [
                          ///---- date seperator
                          if ((i >= 1 &&
                                  data.ditambahkan
                                          .toString()
                                          .substring(0, 10) !=
                                      state.data[i - 1].ditambahkan
                                          .toString()
                                          .substring(0, 10)) ||
                              i == 0)
                            Row(children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  color: Colors.grey[700],
                                  child: Text(
                                    data.ditambahkan
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ]),

                          ///------
                          StockviewCard(data, Key(data.id.toString())),
                        ],
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

class StockviewCard extends StatefulWidget {
  @override
  Key get key => _key;
  final Key _key;

  final ItemTr data;
  StockviewCard(this.data, this._key);

  @override
  _StockviewCardState createState() => _StockviewCardState();
}

class _StockviewCardState extends State<StockviewCard> {
  double horizontal = 0.0;
  @override
  Widget build(BuildContext context) {
    var hargaBeli = numFormat.format(widget.data.hargaBeli);
    var hargaJual = numFormat.format(widget.data.hargaJual);
    var totalBeli = numFormat.format(widget.data.pcs! * widget.data.hargaBeli!);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        print(details.delta);
        setState(() {
          horizontal += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        var width = MediaQuery.of(context).size.width;
        if (horizontal >= width * 0.5) {
          setState(() {
            horizontal = width;
          });
        } else if (horizontal <= width * -0.5) {
          setState(() {
            horizontal = -width;
          });
        } else {
          setState(() {
            horizontal = 0.0;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
            child: ListTile(
              isThreeLine: true,
              // shape: RoundedRectangleBorder( ),
              // tileColor: Colors.white,
              title: Text(''),
              subtitle: Row(
                children: [
                  Text('' + '\n' + '\n'),
                  Expanded(
                    child: Container(),
                  ),
                  Text(' \n' + '\n')
                ],
              ),
            ),
          ),
          Positioned.fill(
              child: Container(
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Are you sure want to delete?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          BlocProvider.of<StockviewBloc>(context)
                              .add(DeleteEntry(widget.data));
                        },
                        child:
                            Text('Yes', style: TextStyle(color: Colors.white))),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          horizontal = 0.0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      )),
                ],
              ),
            ),
          )),
          AnimatedContainer(
            duration: Duration(milliseconds: 450),
            transform: Matrix4.identity()..translate(horizontal),
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(),
              boxShadow: [
                BoxShadow(blurRadius: 8, color: Colors.black26),
              ],
              color: Colors.white,
            ),
            child: ListTile(
              isThreeLine: true,
              // shape: RoundedRectangleBorder( ),
              // tileColor: Colors.white,
              title: Text(widget.data.name.toString()),
              subtitle: Row(
                children: [
                  Text('Tempat beli: ${widget.data.tempatBeli}' +
                      '\nTanggal beli : ${widget.data.ditambahkan.toString().substring(0, 10)}' +
                      '\nJumlah item : ${widget.data.pcs}pcs'),
                  Expanded(
                    child: Container(),
                  ),
                  Text('Harga jual : $hargaJual \nHarga beli : $hargaBeli' +
                      '\nTotal beli : $totalBeli')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBox extends StatelessWidget {
  final dateFrom = TextEditingController();
  final dateTo = TextEditingController();

  ///*Edit this var plz-----------------
  // final dateFromFull, dateToFull;
  final namaBarang = TextEditingController();
  final int dropdownValue = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockviewBloc, StockviewState>(
      builder: (context, state) {
        if (state is StockviewLoaded) {
          namaBarang.text = state.filter.nama ?? 'a';
          return Container(
            // color: Colors.blue,
            // margin: EdgeInsets.all(18.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 8.0,
                //     color: Colors.grey,
                //     offset: Offset(8.0, 8.0),
                //   ),
                //   // BoxShadow(
                //   //   blurRadius: 8.0,
                //   //   color: Colors.white,
                //   //   offset: Offset(-8.0, -8.0),
                //   // )
                // ],
                border: Border.all(color: Colors.grey[50]!),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.0))),
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
                          // dateFromFull = selectedDate.toString();
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
                          // dateToFull = selectedDate.toString();
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
                        onChanged: (dynamic v) {
                          // dropdownValue = v;
                        }),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // print(namaBarang.text + dateFromFull + dateToFull);
                          BlocProvider.of<StockviewBloc>(context)
                              .add(FilterChange(
                            name: namaBarang.text,
                            // dateStart: dateFromFull,
                            // dateEnd: dateToFull,
                          ));

                          Navigator.pop(context);
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
