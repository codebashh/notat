part of 'cubit.dart';

abstract class NotebookState extends Equatable {
  final List<Notebook>? allNoteBooks;
  const NotebookState({this.allNoteBooks});

  @override
  List<Object> get props => [];
}

class NotebookInitial extends NotebookState {}

class NotebookLoadingData extends NotebookState {
  const NotebookLoadingData();
}

class NotebookDataLoaded extends NotebookState {
  const NotebookDataLoaded(List<Notebook>? allNoteBooks)
      : super(allNoteBooks: allNoteBooks);
}
