import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:noteapp/models/notebook.dart';

import '../local_database_cubit/cubit.dart';

part 'state.dart';

class NotebookCubit extends Cubit<NotebookState> {
  NotebookCubit() : super(NotebookInitial());
  final LocalDatabaseCubit localDatabase = LocalDatabaseCubit();

  getAllNoteBooks() async {
    emit(const NotebookLoadingData());
    List<Notebook> allNoteBooks = await localDatabase.getAllNotebooks();
    emit(NotebookDataLoaded(allNoteBooks));
  }

  Future<void> createAndSaveNotebook(Notebook nb) async {
    emit(const NotebookLoadingData());
    await localDatabase.createNotebook(nb);
    await Future.delayed(const Duration(milliseconds: 500));
    List<Notebook> allNoteBooks = await localDatabase.getAllNotebooks();
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NotebookDataLoaded(allNoteBooks));
  }

  Future<void> editNotebook(Notebook notebook) async {
    emit(const NotebookLoadingData());
    await localDatabase.editNotebook(notebook);
    await Future.delayed(const Duration(milliseconds: 500));
    List<Notebook> allNoteBooks = await localDatabase.getAllNotebooks();
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NotebookDataLoaded(allNoteBooks));
  }

  Future<void> deleteNotebook(Notebook notebook) async {
    emit(const NotebookLoadingData());
    await localDatabase.deleteNotebook(notebook);
    await Future.delayed(const Duration(milliseconds: 500));
    List<Notebook> allNoteBooks = await localDatabase.getAllNotebooks();
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NotebookDataLoaded(allNoteBooks));
  }

  Future<void> reorderNotebook(Notebook nb, int newIndex, int oldIndex) async {
    emit(const NotebookLoadingData());
    await localDatabase.reorderNotebook(nb, newIndex, oldIndex);
    await Future.delayed(const Duration(milliseconds: 200));
    List<Notebook> allNoteBooks = await localDatabase.getAllNotebooks();
    await Future.delayed(const Duration(milliseconds: 200));
    emit(NotebookDataLoaded(allNoteBooks));
  }
}
