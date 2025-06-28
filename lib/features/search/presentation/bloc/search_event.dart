import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchGetAllUsers extends SearchEvent {}

class SearchUserByName extends SearchEvent{
  final String query;

  SearchUserByName(this.query);
}
