import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder<List>(
          future: RepositoryProvider.of<DatabaseRepository>(context)
              .showInsideItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return ListView.builder(
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditItemPage(data: snapshot.data![i])));
                    },
                    title: Text(snapshot.data![i]['NAMA']),
                    subtitle:
                        Text('Harga : ${snapshot.data![i]['HARGA_JUAL']}'),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class EditItemPage extends StatefulWidget {
  final Map data;
  final ItemTr convertedData;
  EditItemPage({required this.data}) : convertedData = ItemTr.fromMap(data);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage>
    with TickerProviderStateMixin {
  SuggestionsBoxController? sbc;

  TextEditingController namec = TextEditingController(),
      hargaJual = TextEditingController(),
      barcodeC = TextEditingController(),
      qtyc = TextEditingController();
  late ItemTr data;
  final _formkey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    data = widget.convertedData;
    sbc = SuggestionsBoxController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data.name != namec.text) {
      namec.text = data.name ?? '';
    }
    if (data.hargaJual?.toString() != hargaJual.text) {
      hargaJual.text = data.hargaJual?.toString() ?? '';
    }
    if (data.barcode != barcodeC.text) {
      barcodeC.text = data.barcode?.toString() ?? '';
    }
    if (data.pcs?.toString() != qtyc.text) {
      qtyc.text = data.pcs?.toString() ?? '';
    }
    return Scaffold(
      appBar: AppBar(title: Text('Edit'), actions: [
        ElevatedButton(
            onPressed: () async {
              print('succ here');
              int? barcode =
                  barcodeC.text.isEmpty ? null : int.parse(barcodeC.text);
              print('succ here');
              await RepositoryProvider.of<DatabaseRepository>(context)
                  .updateItem(data.productId, namec.text,
                      int.parse(hargaJual.text), barcode)
                  .then((value) => Navigator.pop(context));
            },
            child: Text('Save'))
      ]),
      body: Column(
        children: [
          Container(
            child: AnimatedClipRect(
              curve: Curves.ease,
              reverseCurve: Curves.ease,
              duration: Duration(milliseconds: 450),
              horizontalAnimation: false,
              open: true,
              child: Form(
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
                              color: Colors.grey[400]!)
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Material(
                              child: TypeAheadFormField(
                                // autovalidate: true,
                                validator: (text) {
                                  if (text!.length <= 2) {
                                    return '3 or more character';
                                  }
                                  return null;
                                },
                                suggestionsBoxController: sbc,
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: namec,
                                    onChanged: (v) {
                                      // dO Something
                                    },
                                    // style: DefaultTextStyle.of(context)
                                    //     .style
                                    //     .copyWith(fontStyle: FontStyle.italic),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Nama item')),
                                suggestionsCallback: (pattern) async {
                                  var res = await RepositoryProvider.of<
                                          DatabaseRepository>(context)
                                      .showInsideItems(query: pattern);
                                  return res;
                                },
                                itemBuilder: (context, dynamic suggestion) {
                                  return ListTile(
                                    leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion['NAMA']),
                                    subtitle:
                                        Text('\$${suggestion['HARGA_JUAL']}'),
                                  );
                                },
                                onSuggestionSelected:
                                    (dynamic suggestion) async {
                                  // var res = await RepositoryProvider.of<
                                  //         DatabaseRepository>(context)
                                  //     .showInsideStock(
                                  //         idbarang: suggestion['ID']);
                                  // print(res);

                                  /// dO sOMETHING
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text!.isNotEmpty &&
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
                                    ///Do Smthg
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Harga jual per pcs'),
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
                                                await FlutterBarcodeScanner
                                                    .scanBarcode(
                                                        '#ffffff',
                                                        'Cancel',
                                                        false,
                                                        ScanMode.BARCODE);
                                            print(barcodeScan);
                                            barcodeC.text = barcodeScan;
                                          },
                                          child: Icon(Icons.qr_code))),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  enabled: false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // validator: (text) {
                                  //   if (text.isNotEmpty &&
                                  //       !RegExp(r'^[0-9]*$').hasMatch(text)) {
                                  //     return 'must be a number';
                                  //   } else if (text.isEmpty) {
                                  //     return 'tidak boleh kosong';
                                  //   }
                                  //   return null;
                                  // },
                                  controller: qtyc,
                                  onChanged: (v) {},
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: 'jumlah unit'),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Edit Item Page ${widget.data['NAMA']}'),
            ),
          ),
        ],
      ),
    );
  }
}
//------------------------------------------------------

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
              })
        ],
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
                          numFormat.format(data.pcs! * data.hargaBeli!);
                      return Column(
                        children: [
                          if (i >= 1 &&
                              data.ditambahkan.toString().substring(0, 10) !=
                                  state.data[i - 1].ditambahkan
                                      .toString()
                                      .substring(0, 10))
                            Row(children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  color: Colors.grey[700],
                                  child: Text(
                                    data.ditambahkan.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                          Container(
                            margin:
                                EdgeInsets.only(bottom: 8, left: 8, right: 8),
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
                          ),
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
                border: Border.all(color: Colors.grey[50]!),
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

///---------------------------------------------------------------

class AnimatedClipRect extends StatefulWidget {
  @override
  _AnimatedClipRectState createState() => _AnimatedClipRectState();

  final Widget? child;
  final bool? open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;

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
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: widget.duration ?? const Duration(milliseconds: 500),
        reverseDuration: widget.reverseDuration ??
            (widget.duration ?? const Duration(milliseconds: 500)),
        vsync: this,
        value: widget.open! ? 1.0 : 0.0,
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
    widget.open!
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
