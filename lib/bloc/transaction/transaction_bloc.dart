import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/semantics.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:meta/meta.dart';
// import '';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  DatabaseRepository _dbHelper;
  TransactionBloc(DatabaseRepository dbHelper)
      : _dbHelper = dbHelper,
        super(TransactionInitial()) {
    ///do Something
    add(LoadInitial());
  }

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is LoadInitial) {
      print('initial');
      yield TransactionLoaded(
          data: [ItemTr(cardId: Random().nextInt(210), open: true)]);
    }
    if (event is UploadToDB) {
      List<ItemTr> data = (state as TransactionLoaded).data;
      yield TransactionLoading();
      try {
        await _dbHelper.transaction(data);
        yield TransactionInitial();
        add(LoadInitial());
      } catch (e) {
        print('error $e');
        yield (TransactionLoaded(data: data));
      }
    }
    if (event is UpdateItem) {
      var data = (state as TransactionLoaded).data.map((e) {
        return e.cardId != event.item.cardId ? e : event.item;
      }).toList();
      yield TransactionLoading();
      yield TransactionLoaded(data: data);
    }
    if (event is AddItem) {
      if (state is TransactionLoaded) {
        var newItem = ItemTr(cardId: Random().nextInt(210), open: false);
        yield TransactionLoaded(
          data: (state as TransactionLoaded).data + [newItem],
        );
        await Future.delayed(Duration(milliseconds: 50), () {});
        yield TransactionLoaded(
            data: (state as TransactionLoaded).data.map((e) {
          return e.cardId != newItem.cardId ? e : newItem.copywith(open: true);
        }).toList());
      }
    }
    if (event is DeleteItem) {
      print('delete item');
      yield TransactionLoaded(
          data: (state as TransactionLoaded).data.map((e) {
        return e.cardId != event.item!.cardId
            ? e
            : event.item!.copywith(open: false);
      }).toList());

      await Future.delayed(Duration(milliseconds: 500), () {});
      yield TransactionLoaded(
          data: (state as TransactionLoaded)
              .data
              .where((element) => (element.open != false))
              .toList());
    }
  }
}
