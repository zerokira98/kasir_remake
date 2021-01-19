part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<ItemTr> data;
  TransactionLoaded({this.data});
  @override
  List<Object> get props => [data, data.length];
}
