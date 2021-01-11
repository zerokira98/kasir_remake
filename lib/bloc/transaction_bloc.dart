import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/semantics.dart';
import 'package:kasir_remake/model/items.dart';
import 'dart:math' as math;
import 'package:meta/meta.dart';
// import '';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
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
          data: [Item(id: Random().nextInt(210), open: true)]);
    }
    if (event is UpdateItem) {
      yield TransactionLoaded(
          data: (state as TransactionLoaded).data.map((e) {
        return e.id != event.item.id ? e : event.item;
      }).toList());
    }
    if (event is AddItem) {
      if (state is TransactionLoaded) {
        var newItem = Item(id: Random().nextInt(210), open: false);
        yield TransactionLoaded(
          data: (state as TransactionLoaded).data + [newItem],
        );
        await Future.delayed(Duration(milliseconds: 50), () {});
        yield TransactionLoaded(
            data: (state as TransactionLoaded).data.map((e) {
          return e.id != newItem.id ? e : newItem.copywith(open: true);
        }).toList());
      }
    }
    if (event is DeleteItem) {
      print('delete item');
      yield TransactionLoaded(
          data: (state as TransactionLoaded).data.map((e) {
        return e.id != event.item.id ? e : event.item.copywith(open: false);
      }).toList());

      await Future.delayed(Duration(milliseconds: 500), () {});
      print('a2${(state as TransactionLoaded).data}');
      yield TransactionLoaded(
          data: (state as TransactionLoaded)
              .data
              .where((element) => (element.open != false))
              .toList());
      print(
          'a ${(state as TransactionLoaded).data.where((element) => (element != event.item.copywith(open: false))).toList()}');
    }
  }
}
