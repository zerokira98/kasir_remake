part of 'stock_bloc.dart';

@immutable
abstract class StockEvent {}

class InsertNewStock extends StockEvent {
  final Map data;
  InsertNewStock(this.data);
}

class ShowStock extends StockEvent {}
