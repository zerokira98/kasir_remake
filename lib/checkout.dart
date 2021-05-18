import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_remake/bloc/transaction/transaction_bloc.dart';

class CheckOutTr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionInitial) {
            Navigator.pop(context);
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => HomePage()),
            //     ModalRoute.withName('/'));
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoaded) {
              if (state.data.isEmpty)
                return Center(
                  child: Text('Nodata'),
                );
              print(state.data);
              int totalHrg = 0, totalQty = 0;
              for (var a in state.data) {
                totalHrg += (a.hargaJual ?? 0) * (a.pcs ?? 0);
                totalQty += a.pcs ?? 0;
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(5.0),
                        1: FlexColumnWidth(1.0),
                        2: FlexColumnWidth(3.0),
                        3: FlexColumnWidth(2.0),
                      },
                      border: TableBorder.all(),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                            // decoration: BoxDecoration(
                            //   color: Colors.red[50],
                            // ),
                            children: [
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('Nama Produk'),
                                ),
                              ),
                              TableCell(child: Text('qty')),
                              TableCell(child: Text('Harga')),
                            ]),
                        // TableRow(children: [Text('helo')]),
                        for (var e in state.data)
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('${e.namaBarang}'),
                            )),
                            TableCell(
                                child: Text(
                              '${e.pcs} ',
                              textAlign: TextAlign.right,
                            )),
                            TableCell(
                                child: Text(
                              '${e.hargaJual} ',
                              textAlign: TextAlign.right,
                            )),
                          ]),
                        TableRow(children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Total : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                          TableCell(
                              child: Text(
                            '$totalQty',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          TableCell(
                              child: Text(
                            '$totalHrg',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          )),
                        ])
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: MaterialButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Flexible(flex: 1, child: Container()),
                        Expanded(
                          flex: 4,
                          child: MaterialButton(
                            // shape: OutlinedBorder().scale(1.0),
                            color: Colors.green,
                            onPressed: () {
                              BlocProvider.of<TransactionBloc>(context)
                                  .add(UploadToDB());
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                children: [
                  Text('CheckOut'),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}
