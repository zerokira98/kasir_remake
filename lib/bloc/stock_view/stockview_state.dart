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
  final int currentPage;
  StockviewLoaded(this.data, this.filter, {required this.currentPage});
  @override
  List<Object> get props => [data];
}

class Filter extends Equatable {
  final int maxPage;
  final String? nama;
  Filter({this.nama, required this.maxPage});

  @override
  List<Object?> get props => [nama];
}
