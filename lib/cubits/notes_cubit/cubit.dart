import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:noteapp/cubits/local_database_cubit/cubit.dart';

import '../../models/note.dart';

part 'state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());
  LocalDatabaseCubit localDatabase = LocalDatabaseCubit();
  Future<void> getAllNotesBySection(sectionId) async {
    emit(const NotesLoadingData());
    List<Note> allNotes = await localDatabase.getAllNotesBySection(sectionId);
    emit(NotesDataLoaded(allNotes));
  }

  Future<void> createAndSaveNote(Note note) async {
    await localDatabase.createNote(note);
  }

  Future<void> reorderNote(
      Note note, int newIndex, int oldIndex, String sectionId) async {
      emit(const NotesLoadingData());
    await localDatabase.reorderNote(note, newIndex, oldIndex, sectionId);
    List<Note> allNotes = await localDatabase.getAllNotesBySection(sectionId);
    emit(NotesDataLoaded(allNotes));
  }
}
