import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:meta/meta.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc() : super(StockInitial()) {
    ///do smg
    add(StockInitialize());
  }

  @override
  Stream<StockState> mapEventToState(
    StockEvent event,
  ) async* {
    if (state is StockInitial) {
      if (event is StockInitialize) {
        yield StockLoaded([
          ItemTr(
              id: Random().nextInt(510),
              expdate: DateTime.now().add(Duration(days: 690)),
              open: false)
        ]);
        await Future.delayed(Duration(milliseconds: 500));

        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => e.copywith(open: true))
            .toList());
      }
    }
    if (state is StockLoaded) {
      if (event is OnDataChanged) {
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => (e.id == event.item.id) ? event.item : e)
            .toList());
      }
      if (event is UploadtoDB) {
        var data = (state as StockLoaded).data;
        yield (StockLoading());
        await Future.delayed(Duration(seconds: 1));
        try {
          await DBHelper.instance.addItem(data);
          print('here1');
          yield StockInitial();
          print('here2');
          add(StockInitialize());
        } catch (e) {
          print(e);
        }
      }
      if (event is NewStockEntry) {
        yield StockLoaded((state as StockLoaded).data +
            [
              ItemTr(
                  id: Random().nextInt(510),
                  expdate: DateTime.now().add(Duration(days: 690)),
                  open: false)
            ]);

        await Future.delayed(Duration(milliseconds: 500));
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => e.open == false ? e.copywith(open: true) : e)
            .toList());
      }
      if (event is DeleteEntry) {
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => e.id == event.item.id ? e.copywith(open: false) : e)
            .toList());

        await Future.delayed(Duration(milliseconds: 500));
        yield StockLoaded(
          (state as StockLoaded)
              .data
              .where((element) => (element.id != event.item.id))
              .toList(),
        );
      }
    }
  }
}
