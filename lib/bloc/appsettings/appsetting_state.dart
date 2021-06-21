part of 'appsetting_bloc.dart';

abstract class AppsettingState extends Equatable {
  const AppsettingState();
  
  @override
  List<Object> get props => [];
}

class AppsettingInitial extends AppsettingState {}
