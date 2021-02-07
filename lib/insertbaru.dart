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
          actions: [
            InkWell(
              onTap: () {
                var state =
                    (BlocProvider.of<StockBloc>(context).state as StockLoaded);

                bool valids = state.data.every(
                    (element) => element.formkey.currentState.validate());
                if (valids) {
                  print('valids');
                  BlocProvider.of<StockBloc>(context)
                      .add(UploadtoDB(state.data));
                } else {
                  print('not valid');
                }
              },
              child: Container(
                  // width: 56,
                  // height: 56,

                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit',
                        textScaleFactor: 1.1,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.subdirectory_arrow_right,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  )),
            ),
          ],
        ),
        body: BlocListener<StockBloc, StockState>(
          listener: (context, state) {
            if (state is StockLoaded) {
              if (state.error != null) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Error : ${state.error['msg']}'),
                ));
              }
            }
          },
          child: Container(
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
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  elevation: 12.0,
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    BlocProvider.of<StockBloc>(context)
                                        .add(NewStockEntry());
                                    print('tambah\'ed');
                                    // bool valids = state.data.any((element) =>
                                    //     element.formkey.currentState
                                    //         .validate());
                                    // if (valids) {
                                    //   print('valids');
                                    //   BlocProvider.of<StockBloc>(context)
                                    //       .add(UploadtoDB(state.data));
                                    // } else {
                                    //   print('not valid');
                                    // }
                                  },
                                  child: Text(
                                    'Tambah Item',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.0),
                        )
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ));
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
    BlocProvider.of<StockBloc>(context).add(
        OnDataChanged(widget.data.copywith(formkey: _formkey, open: true)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.name != namec.text) {
      namec.text = widget.data.name ?? '';
    }
    if (widget.data.tempatBeli != placec.text) {
      placec.text = widget.data.tempatBeli ?? '';
    }
    if (widget.data.hargaBeli?.toString() != hargaBeli.text) {
      hargaBeli.text = widget.data.hargaBeli?.toString() ?? '';
    }
    if (widget.data.hargaJual?.toString() != hargaJual.text) {
      hargaJual.text = widget.data.hargaJual?.toString() ?? '';
    }
    if (widget.data.pcs?.toString() != qtyc.text) {
      qtyc.text = widget.data.pcs?.toString() ?? '';
    }
    datec.text = widget.data.ditambahkan.toString().substring(0, 10);
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
                print(picked.toString());
                BlocProvider.of<StockBloc>(context).add(
                    OnDataChanged(widget.data.copywith(ditambahkan: picked)));
              }
              FocusScope.of(context).unfocus();
            },
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(labelText: 'Buy date'),
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
          child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: placec,
                onChanged: (v) {
                  BlocProvider.of<StockBloc>(context).add(OnDataChanged(
                      widget.data.copywith(tempatBeli: placec.text)));
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Tempat pembelian'),
              ),
              onSuggestionSelected: (val) {
                BlocProvider.of<StockBloc>(context).add(OnDataChanged(
                    widget.data.copywith(tempatBeli: val['NAMA'])));
              },
              itemBuilder: (context, datas) {
                return ListTile(
                  // leading: Icon(Icons.place),
                  title: Text(datas['NAMA']),
                  // subtitle: Text('\$${datas['HARGA_JUAL']}'),
                );
              },
              suggestionsCallback: (data) {
                return DBHelper.instance.showPlaces(query: data);
              }),
        ),
        // Expanded(
        //     child: Padding(
        //   padding: const EdgeInsets.all(4.0),
        //   child: TextField(
        //     controller: placec,
        //     onChanged: (v) {
        //       BlocProvider.of<StockBloc>(context).add(
        //           OnDataChanged(widget.data.copywith(tempatBeli: placec.text)));
        //     },
        //     keyboardType: TextInputType.text,
        //     decoration: InputDecoration(labelText: 'Tempat pembelian'),
        //   ),
        // )),
      ],
    );
    Widget theForm = Form(
      key: _formkey,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.00),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.0,
                    blurRadius: 12.0,
                    color: Colors.grey[400])
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: TypeAheadFormField(
                    // autovalidate: true,
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
                          .showInsideStock(idbarang: suggestion['ID']);
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (text) {
                              if (text.isNotEmpty &&
                                  !RegExp(r'^[0-9]*$').hasMatch(text)) {
                                return 'must be a number';
                              } else if (text.isEmpty) {
                                return 'tidak boleh kosong';
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Harga beli per pcs'),
                          ),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text.isNotEmpty &&
                              !RegExp(r'^[0-9]*$').hasMatch(text)) {
                            return 'must be a number';
                          } else if (text.isEmpty) {
                            return 'tidak boleh kosong';
                          }
                          return null;
                        },
                        // enabled: false,
                        controller: hargaJual,

                        onChanged: (v) {
                          BlocProvider.of<StockBloc>(context).add(OnDataChanged(
                              widget.data.copywith(
                                  hargaJual: int.parse(hargaJual.text))));
                        },
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Harga jual per pcs'),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text.isNotEmpty &&
                              !RegExp(r'^[0-9]*$').hasMatch(text)) {
                            return 'must be a number';
                          } else if (text.isEmpty) {
                            return 'tidak boleh kosong';
                          }
                          return null;
                        },
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
                  color: Colors.red.withOpacity(0.9),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      // height: 1,
      child: AnimatedClipRect(
        curve: Curves.ease,
        reverseCurve: Curves.ease,
        duration: Duration(milliseconds: 450),
        horizontalAnimation: false,
        open: widget.data.open,
        child: theForm,
      ),
    );
  }

  validate(name, priceBuy, priceSell, qty, place, expdate) {
    // _formkey.currentState.validate();
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

class AnimatedClipRect extends StatefulWidget {
  @override
  _AnimatedClipRectState createState() => _AnimatedClipRectState();

  final Widget child;
  final bool open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Curve reverseCurve;

  ///The behavior of the controller when [AccessibilityFeatures.disableAnimations] is true.
  final AnimationBehavior animationBehavior;

  AnimatedClipRect({
    this.child,
    this.open,
    this.horizontalAnimation = true,
    this.verticalAnimation = true,
    this.alignment = Alignment.center,
    this.duration,
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.animationBehavior = AnimationBehavior.normal,
  });
}

class _AnimatedClipRectState extends State<AnimatedClipRect>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: widget.duration ?? const Duration(milliseconds: 500),
        reverseDuration: widget.reverseDuration ??
            (widget.duration ?? const Duration(milliseconds: 500)),
        vsync: this,
        value: widget.open ? 1.0 : 0.0,
        animationBehavior: widget.animationBehavior);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve ?? widget.curve,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open
        ? _animationController.forward()
        : _animationController.reverse();

    return ClipRect(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _animation.value : 1.0,
            widthFactor: widget.horizontalAnimation ? _animation.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
