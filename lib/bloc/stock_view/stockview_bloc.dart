import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasir_remake/model/item_tr.dart';

part 'stockview_event.dart';
part 'stockview_state.dart';

class StockviewBloc extends Bloc<StockviewEvent, StockviewState> {
  StockviewBloc() : super(StockviewInitial()) {
    add(Initializeview());
  }

  @override
  Stream<StockviewState> mapEventToState(
    StockviewEvent event,
  ) async* {
    if (event is Initializeview) {
      yield StockviewLoaded([ItemTr()], Filter());
    }
  }
}
