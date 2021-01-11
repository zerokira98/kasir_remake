import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kasir_remake/bloc/transaction_bloc.dart';
import 'package:kasir_remake/db.dart';
import 'package:kasir_remake/model/items.dart';

class TransactionItemCard extends StatelessWidget {
  final VoidCallback closeCall;

  final namaC = TextEditingController();
  final qtyC = TextEditingController();
  final totalC = TextEditingController();
  final sbc = SuggestionsBoxController();
  final hargaSatuan = TextEditingController();
  final Item item;
  TransactionItemCard({this.closeCall, this.item});
  @override
  Widget build(BuildContext context) {
    // (BlocProvider.of<TransactionBloc>(context).state as TransactionLoaded).data[index];
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        bool qtySaveDelay = true;
        if (state is TransactionLoaded) {
          namaC.text = item.name ?? '';
          hargaSatuan.text = item.hargaJual?.toString() ?? '';
          if (qtyC.text != item.pcs?.toString())
            qtyC.text = item.pcs?.toString() ?? '';
          totalC.text = qtyC.text.isNotEmpty && hargaSatuan.text.isNotEmpty
              ? (int.parse(qtyC.text) * int.parse(hargaSatuan.text)).toString()
              : '';
          return GestureDetector(
            onHorizontalDragUpdate: (val) {
              print(val.globalPosition);
            },
            child: Stack(
              children: [
                // Expanded(
                // child:
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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
                      TypeAheadFormField(
                        suggestionsBoxController: sbc,
                        suggestionsCallback: (text) async {
                          var a = await DBHelper.instance.showInsideItems(text);
                          return a;
                        },
                        onSuggestionSelected: (suggestion) {
                          qtyC.text = '1';
                          namaC.text = suggestion['NAMA'];
                          hargaSatuan.text =
                              suggestion['HARGA_JUAL'].toString();
                          totalC.text =
                              (int.parse(hargaSatuan.text)).toString();
                          // item.copywith();
                          BlocProvider.of<TransactionBloc>(context)
                              .add(UpdateItem(item.copywith(
                            name: namaC.text,
                            pcs: int.parse(qtyC.text),
                            hargaJual: int.parse(hargaSatuan.text),
                          )));
                        },
                        itemBuilder: (context, result) {
                          return ListTile(
                            leading: Icon(Icons.shopping_cart),
                            title: Text(result['NAMA']),
                            subtitle: Text('\$${result['HARGA_JUAL']}'),
                          );
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: namaC,
                          decoration:
                              InputDecoration(labelText: 'nama produkt'),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: qtyC,
                              onChanged: (s) {
                                var a = RegExp(r'[0-9]');
                                if (a.hasMatch(s) && s.isNotEmpty) {
                                  totalC.text = (int.parse(s) *
                                          int.parse(hargaSatuan.text))
                                      .toString();
                                  Future.delayed(Duration(seconds: 2), () {
                                    BlocProvider.of<TransactionBloc>(context)
                                        .add(UpdateItem(
                                            item.copywith(pcs: int.parse(s))));
                                    FocusScope.of(context).unfocus();
                                  });
                                }
                                // qtyC.selection = TextSelection.fromPosition(
                                //     TextPosition(offset: qtyC.text.length));
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
                              decoration:
                                  InputDecoration(labelText: 'Harga satuan'),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: totalC,
                              decoration:
                                  InputDecoration(labelText: 'Harga total'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: InkWell(
                      onTap: () {
                        BlocProvider.of<TransactionBloc>(context)
                            .add(DeleteItem(item));
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
            ),
          );
        }
      },
    );
  }
}
