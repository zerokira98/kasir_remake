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
  StockLoaded(this.data);
  @override
  // TODO: implement props
  List<Object> get props => [data];
}

class StockError extends StockState {}
