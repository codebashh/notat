part of 'cubit.dart';

abstract class NotesState extends Equatable {
  final List<Note>? allNotes;
  const NotesState({this.allNotes});

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoadingData extends NotesState {
  const NotesLoadingData();
}

class NotesDataLoaded extends NotesState {
  const NotesDataLoaded(List<Note> allNotes) : super(allNotes: allNotes);
}
