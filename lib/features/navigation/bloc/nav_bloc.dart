import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/navigation/bloc/nav_event.dart';
import 'package:snap_loop/features/navigation/bloc/nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavigationState> {
  NavBloc() : super(NavigationState(0)) {
    on<NavigateTo>((event, emit) => emit(NavigationState(event.index)));
  }
}
