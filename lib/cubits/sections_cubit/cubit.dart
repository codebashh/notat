import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:noteapp/cubits/local_database_cubit/cubit.dart';

import '../../models/note.dart';
import '../../models/section.dart';

part 'state.dart';

class SectionsCubit extends Cubit<SectionsState> {
  SectionsCubit() : super(SectionsInitial());
  LocalDatabaseCubit localDatabase = LocalDatabaseCubit();
  Future<void> getAllSectionsAndPages(String noteBookId) async {
    emit(const SectionsLoadingData());
    List<Section> sections = await localDatabase.getAllSections(noteBookId);
    List<Note> notes = await localDatabase.getAllNotesBySection(noteBookId);
    emit(SectionsDataLoaded(sections, notes));
  }

  Future<void> createAndSaveSection(
    Section sec,
  ) async {
    emit(const SectionsLoadingData());
    await localDatabase.createSection(sec);
    await Future.delayed(const Duration(milliseconds: 200));
    List<Section> sections = await localDatabase.getAllSections(sec.reference);
    List<Note> notes = await localDatabase.getAllNotesBySection(sec.reference);
    await Future.delayed(const Duration(milliseconds: 200));
    emit(SectionsDataLoaded(sections, notes));
  }

  Future<void> editAndSaveSection(Section section) async {
    await localDatabase.editSection(section);
  }

  Future<void> deleteSection(Section section) async {
    await localDatabase.deleteSection(section);
  }
}
