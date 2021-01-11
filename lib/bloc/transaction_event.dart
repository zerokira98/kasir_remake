part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadInitial extends TransactionEvent {}

class AddItem extends TransactionEvent {}

class UpdateItem extends TransactionEvent {
  final Item item;
  UpdateItem(this.item);
  @override
  List<Object> get props => [item];
}

class DeleteItem extends TransactionEvent {
  final Item item;
  DeleteItem(this.item);
  @override
  List<Object> get props => [item];
}
