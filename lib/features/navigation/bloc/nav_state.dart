import 'package:equatable/equatable.dart';

abstract class NavState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavigationState extends NavState{
  final int selectedIndex;
  NavigationState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}
