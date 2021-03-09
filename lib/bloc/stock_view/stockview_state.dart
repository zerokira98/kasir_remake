part of 'stockview_bloc.dart';

abstract class StockviewState extends Equatable {
  const StockviewState();

  @override
  List<Object> get props => [];
}

class StockviewInitial extends StockviewState {}

class StockviewLoading extends StockviewState {}

class StockviewLoaded extends StockviewState {
  final List<ItemTr> data;
  final Filter filter;
  StockviewLoaded(this.data, this.filter);
  @override
  List<Object> get props => [data];
}

class Filter extends Equatable {
  final String? nama;
  Filter({this.nama});

  @override
  List<Object?> get props => [nama];
}
