import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_remake/bloc/stock_view/stockview_bloc.dart';
import 'package:kasir_remake/model/item_tr.dart';

part 'card.dart';
part 'filterbox.dart';

final numFormat = new NumberFormat("#,##0.00", "en_US");

class ListOfStockItems extends StatelessWidget {
  final ScrollController _scontrol = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.red,
        child: BlocBuilder<StockviewBloc, StockviewState>(
          builder: (context, state) {
            ///---------- Pagination
            if (state is StockviewLoaded) {
              return Row(
                children: [
                  Expanded(child: Container()),
                  InkWell(
                      onTap: () {
                        if ((state.filter.maxPage / 10).floor() !=
                                state.currentPage - 1 &&
                            state.currentPage != 0) {
                          BlocProvider.of<StockviewBloc>(context).add(
                              FilterChange(
                                  name: state.filter.nama,
                                  page: state.currentPage - 1));
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.arrow_left))),
                  Container(
                    width: 50,
                    color: Colors.grey[350],
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          (state.currentPage + 1).toString(),
                          textScaleFactor: 1.6,
                        ),
                        Text(
                          '/',
                          textScaleFactor: 1.6,
                        ),
                        Text(
                          ((state.filter.maxPage / 10).floor() + 1).toString(),
                          textScaleFactor: 1.6,
                        ),
                      ],
                    )),
                  ),
                  InkWell(
                      onTap: () {
                        print(state.currentPage);
                        print((state.filter.maxPage / 10).floor());
                        if ((state.filter.maxPage / 10).floor() + 1 !=
                            (state.currentPage + 1)) {
                          print('a');
                          BlocProvider.of<StockviewBloc>(context).add(
                              FilterChange(
                                  name: state.filter.nama,
                                  page: state.currentPage + 1));
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.arrow_right))),
                  Expanded(child: Container()),
                ],
              );
            }
            return Container();
          },
        ),
        height: 42,
      ),
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
                  return Scrollbar(
                    // controller: _scontrol,
                    child: ListView.builder(
                      controller: _scontrol,
                      padding: EdgeInsets.only(bottom: 12),
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
                    ),
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
