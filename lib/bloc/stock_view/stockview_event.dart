part of 'stockview_bloc.dart';

abstract class StockviewEvent extends Equatable {
  const StockviewEvent();

  @override
  List<Object> get props => [];
}

class Initializeview extends StockviewEvent {
  // @override
  // List<Object> get props => [];
}

class FilterChange extends StockviewEvent {
  final dateStart, dateEnd, name, sortBy;
  FilterChange({this.name, this.dateStart, this.dateEnd, this.sortBy});
  // @override
  // List<Object> get props => [];
}

class ReloadView extends StockviewEvent {
  // var dateStart, dateEnd, name, sortBy;
  // @override
  // List<Object> get props => [];
}

class DeleteEntry extends StockviewEvent {
  final ItemTr data;
  DeleteEntry(this.data);
}
