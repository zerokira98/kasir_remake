import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appsetting_event.dart';
part 'appsetting_state.dart';

class AppsettingBloc extends Bloc<AppsettingEvent, AppsettingState> {
  AppsettingBloc() : super(AppsettingInitial());

  @override
  Stream<AppsettingState> mapEventToState(
    AppsettingEvent event,
  ) async* {}
}
