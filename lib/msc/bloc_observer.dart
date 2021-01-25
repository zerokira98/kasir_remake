import 'package:flutter_bloc/flutter_bloc.dart';

class NewBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    // print(bloc);
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    print(error);
    super.onError(cubit, error, stacktrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    // print(bloc);
    super.onTransition(bloc, transition);
  }
}
