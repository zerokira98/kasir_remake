import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:kasir_remake/msc/db.dart';

part 'stockview_event.dart';
part 'stockview_state.dart';

class StockviewBloc extends Bloc<StockviewEvent, StockviewState> {
  DatabaseRepository _dbHelper;
  StockviewBloc(DatabaseRepository dbHelper)
      : _dbHelper = dbHelper,
        super(StockviewInitial()) {
    add(Initializeview());
  }

  @override
  Stream<StockviewState> mapEventToState(
    StockviewEvent event,
  ) async* {
    if (event is Initializeview) {
      List<dynamic> dbres = await (_dbHelper.showInsideStock(showName: true));
      List<ItemTr> convert = dbres.map<ItemTr>((e) {
        var dateDb = e['ADD_DATE'].toString();
        bool isUtc = dateDb.contains('Z');

        return ItemTr(
          name: e['NAMA'],
          // barcode: null,
          ditambahkan: isUtc
              ? DateTime.parse(dateDb).toLocal()
              : DateTime.parse(dateDb + 'Z').toLocal(),
          expdate: DateTime.parse(e['EXP_DATE']),
          pcs: e['QTY'],
          hargaBeli: e['PRICE'],
          hargaJual: e['HARGA_JUAL'],
          tempatBeli: e['SUPPLIER'],
          // id: ,
        );
      }).toList();
      yield StockviewLoaded(convert, Filter());
    }
    if (event is FilterChange) {
      yield StockviewLoading();
      List dbres = await (_dbHelper.showInsideStock(
          showName: true,
          name: event.name,
          startDate: event.dateStart,
          endDate: event.dateEnd));
      List<ItemTr> convert = dbres.map<ItemTr>((e) {
        var dateDb = e['ADD_DATE'].toString();
        bool isUtc = dateDb.contains('Z');
        var ditambahkan = isUtc
            ? DateTime.parse(dateDb).toLocal()
            : DateTime.parse(dateDb + 'Z').toLocal();
        return ItemTr(
          name: e['NAMA'],
          // barcode: null,
          ditambahkan: ditambahkan,
          pcs: e['QTY'],
          expdate: DateTime.parse(e['EXP_DATE']),
          hargaBeli: e['PRICE'],
          hargaJual: e['HARGA_JUAL'],
          tempatBeli: e['SUPPLIER'],
          // id: ,
        );
      }).toList();
      yield StockviewLoaded(convert, Filter());
    }
  }
}
