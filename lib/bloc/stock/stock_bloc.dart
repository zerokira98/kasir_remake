import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kasir_remake/msc/db.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:meta/meta.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  DatabaseRepository _dbHelper;
  StockBloc(DatabaseRepository dbHelper)
      : _dbHelper = dbHelper,
        super(StockInitial()) {
    ///do smg
    add(StockInitialize(success: false));
  }
  verify(List<ItemTr> data) {
    return data.any((e) => e.name != null);
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
              // formkey: GlobalKey<FormState>(),
              ditambahkan: DateTime.now().toUtc(),
              expdate: DateTime.now().add(Duration(days: 600)),
              open: false)
        ], success: event.success);
        await Future.delayed(Duration(seconds: 1), () async* {
          yield (state as StockLoaded).clearMsg();
        });
        // await Future.delayed(Duration(milliseconds: 500));

        // yield StockLoaded((state as StockLoaded)
        //     .data
        //     .map((e) => e.copywith(open: true))
        //     .toList());
      }
    }
    if (state is StockLoaded) {
      // if (event is StockInitialize) {
      //   if (event.success) {
      //   } else {
      //     yield StockInitial();
      //     add(StockInitialize(success: false));
      //   }
      // }
      if (event is OnDataChanged) {
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => (e.id == event.item.id) ? event.item : e)
            .toList());
      }
      if (event is UploadtoDB) {
        var data = (state as StockLoaded).data;
        // var state =
        //             (BlocProvider.of<StockBloc>(context).state as StockLoaded);
        bool valids = data.isNotEmpty
            ? data.every((element) => element.formkey!.currentState!.validate())
            : false;
        // verify(data);
        // if (data.any((e) => e.formkey.currentState.validate())) {
        //   yield StockLoaded(data, error: {'msg': 'data tidak valid'});
        //   await Future.delayed(Duration(seconds: 4));
        //   yield StockLoaded(data, error: null);
        // } else {
        if (valids) {
          yield (StockLoading());
          await Future.delayed(Duration(seconds: 1));
          try {
            await _dbHelper.addItem(data);
            yield StockInitial();
            add(StockInitialize(success: true));
          } catch (e) {
            yield StockLoaded(data, error: {'msg': e.toString()});
            await Future.delayed(Duration(seconds: 1));
            yield (state as StockLoaded).clearMsg();
          }
        } else if (data.isEmpty) {
          print('error no data');
          // yield (StockLoading());
          // await Future.delayed(Duration(seconds: 2));
          yield StockInitial();
          add(StockInitialize(success: false));
        }
        // }
      }
      if (event is NewStockEntry) {
        List<ItemTr> prevData = (state as StockLoaded).data;
        // DateTime Function() ditambahkan = () {
        //   if (prevData.isNotEmpty) {
        //     return prevData.last.ditambahkan;
        //   }
        //   return DateTime.now().toUtc();
        // };
        DateTime? ditambahkan = prevData.isNotEmpty
            ? prevData.last.ditambahkan
            : DateTime.now().toUtc();
        yield StockLoaded((state as StockLoaded).data +
            [
              ItemTr(
                  id: Random().nextInt(510),
                  ditambahkan: ditambahkan,
                  expdate: DateTime.now().add(Duration(days: 690)),
                  open: false)
            ]);

        await Future.delayed(Duration(milliseconds: 100));
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

        await Future.delayed(Duration(milliseconds: 550));
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
