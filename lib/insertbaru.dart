import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kasir_remake/db.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  int length = 1;
  void delete() {
    setState(() {
      length--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.only(top: 12.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < length; i++) InsertProductCard(delete),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    length++;
                  });
                  print('tambah\'ed');
                },
                child: Text('Tambah Item'),
              )
              // InsertProductCard(),
              // InsertProductCard(),
              // InsertProductCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class InsertProductCard extends StatefulWidget {
  final VoidCallback delete;
  InsertProductCard(this.delete);
  @override
  _InsertProductCardState createState() => _InsertProductCardState();
}

class _InsertProductCardState extends State<InsertProductCard> {
  SuggestionsBoxController sbc;
  TextEditingController namec = TextEditingController(),
      hargaBeli = TextEditingController(),
      hargaJual = TextEditingController(),
      datec = TextEditingController(),
      placec = TextEditingController(),
      qtyc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  VoidCallback delete;
  @override
  void initState() {
    delete = this.widget.delete;
    // harga.text = '5000';
    sbc = SuggestionsBoxController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  padding: EdgeInsets.all(8.0),
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
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontStyle: FontStyle.italic),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nama item')),
                    suggestionsCallback: (pattern) async {
                      var res =
                          await DBHelper.instance.showInsideItems(pattern);
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
                      hargaBeli.text = res.last['PRICE'].toString();
                      namec.text = suggestion['NAMA'];
                      // hargaBeli.text = suggestion['']
                      hargaJual.text = suggestion['HARGA_JUAL'].toString();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (text) {
                          if (text.isNotEmpty &&
                              !RegExp(r'^[0-9]').hasMatch(text)) {
                            return 'must be a number';
                          }
                          return null;
                        },
                        controller: hargaBeli,
                        decoration:
                            InputDecoration(labelText: 'Harga beli per pcs'),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        // enabled: false,
                        controller: hargaJual,
                        decoration:
                            InputDecoration(labelText: 'Harga jual per pcs'),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: qtyc,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'jumlah unit'),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            setState(() {
                              datec.text = picked.toString().substring(0, 19);
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.datetime,
                        decoration:
                            InputDecoration(labelText: 'Expiration date'),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: placec,
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: 'Tempat pembelian'),
                      ),
                    )),
                  ],
                ),
                // Expanded(
                //   child: Container(),
                // ),
                RaisedButton(
                  onPressed: () {
                    submit();
                  },
                  child: Text('Submit'),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: RaisedButton(
                //           onPressed: () {
                //             print(_formkey.currentState.validate());
                //           },
                //           child: Text('validate'),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                delete();
              },
              icon: Container(color: Colors.red, child: Icon(Icons.close)),
              color: Colors.white,
              highlightColor: Colors.green,
              splashColor: Colors.green,
              focusColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  validate(name, priceBuy, priceSell, qty, place, expdate) {
    // if (name.legth == 0)
    //   return {'error': ERROR.NAME, 'error_msg': 'invalid Name'};
  }

  void submit() {
    var name = namec.text;
    var priceBuy = hargaBeli.text.isNotEmpty ? hargaBeli.text : '5000';
    var priceSell = hargaJual.text.isNotEmpty ? hargaJual.text : '6000';
    var qty = qtyc.text;
    var expdate = datec.text.isNotEmpty ? datec.text : 'none';
    var place = placec.text.isNotEmpty ? placec.text : 'none';
    validate(name, priceBuy, priceSell, qty, place, expdate);
    DBHelper.instance.addItem(name, priceBuy, priceSell, qty, place, expdate);
  }
}
