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
      yield TransactionLoaded(data: [Item(id: Random().nextInt(210))]);
    }
    if (event is UpdateItem) {
      yield TransactionLoaded(
          data: (state as TransactionLoaded).data.map((e) {
        return e.id != event.item.id ? e : event.item;
      }).toList());
    }
    if (event is AddItem) {
      if (state is TransactionLoaded) {
        print('add item');
        // yield* _mapadd(event);
        yield TransactionLoaded(
          data: (state as TransactionLoaded).data +
              [Item(id: Random().nextInt(210))],
        );
      }
    }
    if (event is DeleteItem) {
      print('delete item');
      print((state as TransactionLoaded).data);
      yield TransactionLoaded(
          data: (state as TransactionLoaded)
              .data
              .where((element) => (element != event.item))
              .toList());
    }
  }

  Stream<TransactionState> _mapadd(TransactionEvent event) async* {
    final List<Item> a = List.from(((state as TransactionLoaded).data)
      ..add(Item(
        id: Random().nextInt(210),
      )));
    print(a);
    yield TransactionLoaded(data: a);
  }
}
