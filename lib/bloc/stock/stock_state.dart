part of 'stock_bloc.dart';

@immutable
abstract class StockState extends Equatable {
  @override
  List<Object> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<ItemTr> data;
  final Map error;
  StockLoaded(this.data, {this.error});
  @override
  List<Object> get props => [data, error];
  @override
  String toString() {
    return 'length : ${data}';
  }
}

class StockError extends StockState {}
