part of 'cubit.dart';

abstract class LocalDatabaseState extends Equatable {
  final List<MessageModal>? pageMessages;

  const LocalDatabaseState({this.pageMessages});

  @override
  List<Object> get props => [];
}

class LocalDatabaseInitial extends LocalDatabaseState {}

class LocalDatabaseLoadingState extends LocalDatabaseState {
  const LocalDatabaseLoadingState();
}

class LocalDatabaseDataSuccess extends LocalDatabaseState {
  const LocalDatabaseDataSuccess(List<MessageModal> messages)
      : super(pageMessages: messages);
}
