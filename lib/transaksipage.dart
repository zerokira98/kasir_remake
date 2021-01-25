import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kasir_remake/bloc/transaction/transaction_bloc.dart';
import 'package:kasir_remake/checkout.dart';
import 'package:kasir_remake/trItemCard.dart';
import 'package:intl/intl.dart';

final numFormat = new NumberFormat("#,##0.00", "en_US");

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  @override
  initState() {
    // datas.add('data');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoaded) {
                    List<Widget> data = state.data
                        .map<Widget>((e) => TransactionItemCard(
                              item: e,
                              key: Key(e.id.toString()),
                            ))
                        .toList();
                    return Column(
                      children: data +
                          <Widget>[
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  child: MaterialButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      BlocProvider.of<TransactionBloc>(context)
                                          .add(AddItem());
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Tambah barang',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )),
                                  ),
                                )),
                              ],
                            ),
                          ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),

          /// Bottom total + checkout button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                border: Border(
                  top: BorderSide(width: 2.0, color: Colors.blueGrey[300]),
                  bottom: BorderSide(width: 2.0, color: Colors.blueGrey[300]),
                )),
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container(
                  // color: Colors.red,
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      var total = 0;
                      if (state is TransactionLoaded) {
                        state.data.forEach((e) {
                          if (e.pcs != null && e.hargaJual != null) {
                            total += e.pcs * e.hargaJual;
                          }
                        });
                        // if(total.length>4);
                        return Text(
                          'Total : ${numFormat.format(total)}',
                          textScaleFactor: 1.25,
                          style: TextStyle(color: Colors.white, shadows: [
                            Shadow(blurRadius: 4.0, color: Colors.green),
                          ]),
                        );
                      }
                      return Text('total : ');
                    },
                  ),
                )),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CheckOutTr()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(blurRadius: 4.0, color: Colors.black87)
                      ],
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                        Text(
                          'CheckOut',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
