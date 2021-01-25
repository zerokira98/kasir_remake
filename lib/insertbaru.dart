import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kasir_remake/bloc/stock/stock_bloc.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/model/item_tr.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masuk Barang'),
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 12.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: Colors.grey[100],
        child: SingleChildScrollView(
          child: BlocBuilder<StockBloc, StockState>(
            builder: (context, state) {
              if (state is StockLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is StockLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < state.data.length; i++)
                      InsertProductCard(
                          state.data[i], Key(state.data[i].id.toString())),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<StockBloc>(context)
                            .add(NewStockEntry());
                        print('tambah\'ed');
                      },
                      child: Text('Tambah Item'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<StockBloc>(context)
                            .add(UploadtoDB(state.data));
                        // submit();
                      },
                      child: Text('Submit'),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class InsertProductCard extends StatefulWidget {
  @override
  Key get key => _key;
  final Key _key;
  final ItemTr data;
  InsertProductCard(this.data, this._key);
  @override
  _InsertProductCardState createState() => _InsertProductCardState();
}

class _InsertProductCardState extends State<InsertProductCard>
    with TickerProviderStateMixin {
  SuggestionsBoxController sbc;
  TextEditingController namec = TextEditingController(),
      hargaBeli,
      hargaJual = TextEditingController(),
      datec = TextEditingController(),
      placec = TextEditingController(),
      barcodeC = TextEditingController(),
      qtyc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    sbc = SuggestionsBoxController();
    hargaBeli = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.name != namec.text) {
      namec.text = widget.data.name ?? '';
    }
    if (widget.data.hargaBeli?.toString() != hargaBeli.text) {
      hargaBeli.text = widget.data.hargaBeli?.toString() ?? '';
    }
    if (widget.data.hargaJual?.toString() != hargaJual.text) {
      hargaJual.text = widget.data.hargaJual?.toString() ?? '';
    }
    Widget bottom = Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: datec,
            // enabled: false,
            onTap: () async {
              FocusScope.of(context).unfocus();
              final DateTime picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  initialDatePickerMode: DatePickerMode.day,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101));
              if (picked != null) {
                datec.text = picked.toString().substring(0, 19);

                BlocProvider.of<StockBloc>(context)
                    .add(OnDataChanged(widget.data.copywith(expdate: picked)));
              }
              FocusScope.of(context).unfocus();
            },
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(labelText: 'Expiration date'),
          ),
        )),
        Expanded(
          child: TextFormField(
            controller: barcodeC,
            decoration: InputDecoration(
                labelText: 'barcode',
                suffixIcon: InkWell(
                    onTap: () async {
                      String barcodeScan =
                          await FlutterBarcodeScanner.scanBarcode(
                              '#ffffff', 'Cancel', false, ScanMode.BARCODE);
                      print(barcodeScan);
                      barcodeC.text = barcodeScan;

                      BlocProvider.of<StockBloc>(context).add(OnDataChanged(
                          widget.data.copywith(barcode: barcodeScan)));
                    },
                    child: Icon(Icons.qr_code))),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: placec,
            onChanged: (v) {
              BlocProvider.of<StockBloc>(context).add(
                  OnDataChanged(widget.data.copywith(tempatBeli: placec.text)));
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Tempat pembelian'),
          ),
        )),
      ],
    );
    Widget theForm = Form(
      key: _formkey,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(12.0),
            padding: EdgeInsets.all(8.00),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.0,
                    blurRadius: 22.0,
                    color: Colors.grey[500])
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: TypeAheadFormField(
                    autovalidate: true,
                    validator: (text) {
                      if (text.length <= 2) {
                        return '3 or more character';
                      }
                      return null;
                    },
                    suggestionsBoxController: sbc,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: namec,
                        onChanged: (v) {
                          BlocProvider.of<StockBloc>(context)
                              .add(OnDataChanged(widget.data.copywith(
                            name: namec.text,
                          )));
                        },
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontStyle: FontStyle.italic),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nama item')),
                    suggestionsCallback: (pattern) async {
                      var res = await DBHelper.instance
                          .showInsideItems(query: pattern);
                      return res;
                      // return await BackendService.getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text(suggestion['NAMA']),
                        subtitle: Text('\$${suggestion['HARGA_JUAL']}'),
                      );
                    },
                    onSuggestionSelected: (suggestion) async {
                      var res = await DBHelper.instance
                          .showInsideStock(suggestion['ID']);
                      // print(res);
                      BlocProvider.of<StockBloc>(context)
                          .add(OnDataChanged(widget.data.copywith(
                        name: suggestion['NAMA'],
                        hargaBeli: res.last['PRICE'],
                        hargaJual: suggestion['HARGA_JUAL'],
                      )));
                      // hargaBeli.text = res.last['PRICE'].toString();
                      // namec.text = suggestion['NAMA'];
                      // // hargaBeli.text = suggestion['']
                      // hargaJual.text = suggestion['HARGA_JUAL'].toString();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            validator: (text) {
                              if (text.isNotEmpty &&
                                  !RegExp(r'^[0-9]').hasMatch(text)) {
                                return 'must be a number';
                              }
                              return null;
                            },
                            onChanged: (v) {
                              BlocProvider.of<StockBloc>(context)
                                  .add(OnDataChanged(widget.data.copywith(
                                hargaBeli: int.parse(hargaBeli.text),
                              )));
                            },
                            controller: hargaBeli,
                            decoration: InputDecoration(
                                labelText: 'Harga beli per pcs'),
                          ),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        // enabled: false,
                        controller: hargaJual,

                        onChanged: (v) {
                          BlocProvider.of<StockBloc>(context).add(OnDataChanged(
                              widget.data.copywith(
                                  hargaJual: int.parse(hargaJual.text))));
                        },
                        decoration:
                            InputDecoration(labelText: 'Harga jual per pcs'),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: qtyc,
                        onChanged: (v) {
                          BlocProvider.of<StockBloc>(context).add(OnDataChanged(
                              widget.data.copywith(pcs: int.parse(qtyc.text))));
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'jumlah unit'),
                      ),
                    )),
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                      Expanded(flex: 3, child: bottom)
                  ],
                ),
                if (MediaQuery.of(context).orientation == Orientation.portrait)
                  bottom
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: InkWell(
              onTap: () {
                BlocProvider.of<StockBloc>(context)
                    .add(DeleteEntry(widget.data));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.red.withOpacity(0.95),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              // highlightColor: Colors.green,
              // splashColor: Colors.green,
              // focusColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    return AnimatedSize(
      duration: Duration(milliseconds: 450),
      vsync: this,
      curve: Curves.ease,
      child: widget.data.open
          ? AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: widget.data.open ? 1.0 : 0.0,
              child: theForm,
            )
          : Container(
              height: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: widget.data.open ? 0.0 : 1.0,
                child: theForm,
              ),
            ),
    );
  }

  validate(name, priceBuy, priceSell, qty, place, expdate) {
    // if (name.legth == 0)
    //   return {'error': ERROR.NAME, 'error_msg': 'invalid Name'};
  }

  // void submit() {
  //   var name = namec.text;
  //   var priceBuy = hargaBeli.text.isNotEmpty ? hargaBeli.text : '';
  //   var priceSell = hargaJual.text.isNotEmpty ? hargaJual.text : '';
  //   var qty = qtyc.text;
  //   var expdate = datec.text.isNotEmpty ? datec.text : 'none';
  //   var place = placec.text.isNotEmpty ? placec.text : 'none';
  //   validate(name, priceBuy, priceSell, qty, place, expdate);
  //   var dataFinal = ItemTr(
  //     name: name,
  //     hargaBeli: int.parse(priceBuy),
  //     hargaJual: int.parse(priceSell),
  //     pcs: int.parse(qty),
  //     tempatBeli: place,
  //   );
  // BlocProvider.of<StockBloc>(context).add(UploadtoDB(dataFinal));
  // }
}
