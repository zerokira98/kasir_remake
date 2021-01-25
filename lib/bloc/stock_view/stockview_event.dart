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
  var dateStart, dateEnd, name, sortBy;
  // @override
  // List<Object> get props => [];
}
