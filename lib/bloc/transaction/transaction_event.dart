part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadInitial extends TransactionEvent {}

class AddItem extends TransactionEvent {}

class UploadToDB extends TransactionEvent {}

class UpdateItem extends TransactionEvent {
  final ItemTr item;
  UpdateItem(this.item);
  @override
  List<Object> get props => [item];
}

class DeleteItem extends TransactionEvent {
  final ItemTr item;
  DeleteItem(this.item);
  @override
  List<Object> get props => [item];
}
