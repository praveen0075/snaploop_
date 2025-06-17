import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {}

class NavigateTo extends NavEvent {
  final int index;
  NavigateTo(this.index);

  @override
  List<Object?> get props => [index];
}
