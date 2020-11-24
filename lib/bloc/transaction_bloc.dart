import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    ///do Something
  }

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {}
}
