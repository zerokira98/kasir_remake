import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kasir_remake/bloc/transaction/transaction_bloc.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class TransactionItemCard extends StatefulWidget {
  @override
  Key? get key => _key;
  final Key? _key;

  final ItemTr item;
  TransactionItemCard({required this.item, Key? key}) : _key = key;

  @override
  _TransactionItemCardState createState() => _TransactionItemCardState();
}

class _TransactionItemCardState extends State<TransactionItemCard>
    with TickerProviderStateMixin {
  final namaC = TextEditingController();

  final qtyC = TextEditingController();

  final totalC = TextEditingController();

  final sbc = SuggestionsBoxController();

  final hargaSatuan = TextEditingController();

  // Future? delayQty;

  var barcodeC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // (BlocProvider.of<TransactionBloc>(context).state as TransactionLoaded).data[index];
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoaded) {
          print(widget.item.name);
          // namaC.text = widget.item.name ?? '';
          if (namaC.text != widget.item.name?.toString())
            namaC.text = widget.item.name?.toString() ?? '';
          hargaSatuan.text = widget.item.hargaJual?.toString() ?? '';
          barcodeC.text = widget.item.barcode?.toString() ?? '';
          if (qtyC.text != widget.item.pcs?.toString())
            qtyC.text = widget.item.pcs?.toString() ?? '';
          totalC.text = qtyC.text.isNotEmpty && hargaSatuan.text.isNotEmpty
              ? (int.parse(qtyC.text) * int.parse(hargaSatuan.text)).toString()
              : '';
          Widget theWidget = Container(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
            margin: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 14.0,
                )
              ],
              borderRadius: BorderRadius.circular(16),
              // border: Border.all()
            ),
            child: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TypeAheadFormField(
                        suggestionsBoxController: sbc,
                        suggestionsCallback: (text) async {
                          var a =
                              await RepositoryProvider.of<DatabaseRepository>(
                                      context)
                                  .showInsideItems(query: text);
                          return a;
                        },
                        onSuggestionSelected: (dynamic suggestion) {
                          totalC.text = (suggestion['HARGA_JUAL']).toString();
                          print('product id: ${suggestion['ID']}');
                          BlocProvider.of<TransactionBloc>(context)
                              .add(UpdateItem(widget.item.copywith(
                            name: suggestion['NAMA'],
                            pcs: 1,
                            barcode: suggestion['BARCODE']?.toString() ?? '',
                            productId: suggestion['ID'],
                            hargaJual: suggestion['HARGA_JUAL'],
                          )));
                        },
                        itemBuilder: (context, dynamic result) {
                          return ListTile(
                            leading: Icon(Icons.shopping_cart),
                            title: Text(result['NAMA']),
                            subtitle: Text('\$${result['HARGA_JUAL']}'),
                          );
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                          onChanged: (s) {
                            BlocProvider.of<TransactionBloc>(context).add(
                                UpdateItem(
                                    widget.item.copywith(name: namaC.text)));
                          },
                          controller: namaC,
                          decoration:
                              InputDecoration(labelText: 'nama produkt'),
                        ),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: barcodeC,
                      decoration: InputDecoration(
                          labelText: 'Barcode',
                          suffixIcon: InkWell(
                              onTap: () async {
                                String barcodeScan =
                                    await FlutterBarcodeScanner.scanBarcode(
                                        '#ffffff',
                                        'Cancel',
                                        false,
                                        ScanMode.BARCODE);
                                print(barcodeScan);
                                List search = await RepositoryProvider.of<
                                        DatabaseRepository>(context)
                                    .showInsideItems(barcode: barcodeScan);
                                if (search.isNotEmpty) {
                                  BlocProvider.of<TransactionBloc>(context)
                                      .add(UpdateItem(widget.item.copywith(
                                    name: search[0]!['NAMA'],
                                    pcs: 1,
                                    barcode: search[0]!['BARCODE'].toString(),
                                    productId: search[0]!['ID'],
                                    hargaJual: search[0]!['HARGA_JUAL'],
                                  )));
                                }
                                barcodeC.text = barcodeScan;
                              },
                              child: Icon(Icons.qr_code))),
                    ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: qtyC,
                        onChanged: (s) {
                          var a = RegExp(r'[0-9]');
                          if (a.hasMatch(s) && s.isNotEmpty) {
                            totalC.text =
                                (int.parse(s) * int.parse(hargaSatuan.text))
                                    .toString();
                            BlocProvider.of<TransactionBloc>(context).add(
                                UpdateItem(
                                    widget.item.copywith(pcs: int.parse(s))));
                          }
                        },
                        decoration: InputDecoration(labelText: 'Qty'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: hargaSatuan,
                        enabled: false,
                        decoration: InputDecoration(labelText: 'Harga satuan'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: totalC,
                        decoration: InputDecoration(labelText: 'Harga total'),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          );
          return Stack(
            children: [
              AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  vsync: this,
                  child: widget.item.open!
                      ? theWidget
                      : Container(
                          height: 2,
                          child: theWidget,
                        )),
              Positioned(
                right: 8,
                top: 8,
                child: InkWell(
                    onTap: () {
                      BlocProvider.of<TransactionBloc>(context)
                          .add(DeleteItem(widget.item));
                    },
                    child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.blueGrey[50],
                        ))),
              ),
              // ),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
