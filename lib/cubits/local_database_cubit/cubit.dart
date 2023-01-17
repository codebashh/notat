import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/configs/app_directories.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/models/notebook.dart';
import 'package:noteapp/models/section.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:noteapp/utils/local_database_management_helper.dart';
import 'package:sqflite/sqflite.dart';
part 'state.dart';
part 'data_provider.dart';
part 'repository.dart';

class LocalDatabaseCubit extends Cubit<LocalDatabaseState> {
  LocalDatabaseCubit() : super(LocalDatabaseInitial());

  static LocalDatabaseCubit cubit(BuildContext context,
          [bool listen = false]) =>
      BlocProvider.of<LocalDatabaseCubit>(context, listen: listen);

  LocalDatabaseRepository dataRepository = LocalDatabaseRepository();

  Future<void> initDatabase() async {
    try {
      await dataRepository.initDirectoriesAndDatabase();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createNotebook(Notebook nb) async {
    await dataRepository.createNotebook(nb);
  }

  Future<List<MessageModal>> fetchPageMessages(String pageID) async {
    emit(const LocalDatabaseLoadingState());
    List<MessageModal> pageMessages =
        await dataRepository.getPageMessages(pageID);
    return pageMessages;
  }

  Future<void> insertPageMessage(MessageModal message) async {
    await dataRepository.insertMessage(message);
  }

  Future<void> insertPageImage(String path, String pageID) async {
    MessageModal mm = MessageModal(
        actualMessage: path,
        messageDate: DateTime.now().toIso8601String(),
        messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
        messageType: ChatMessageType.image,
        pageID: pageID);
    await insertPageMessage(mm);
  }

  Future<void> insertPageVideo(String path, String pageID) async {
    MessageModal mm = MessageModal(
        actualMessage: path,
        messageDate: DateTime.now().toIso8601String(),
        messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
        messageType: ChatMessageType.video,
        pageID: pageID);

    await insertPageMessage(mm);
  }

  Future<void> printMessageTable(String pageID) async {
    dataRepository.printMessageTable(
      "__Messages_table",
      "pageID",
      pageID,
    );
  }

  Future<void> createTable(String tableConfiguration) async {
    dataRepository.createTable(tableConfiguration);
  }

  Future<void> reorderMessage(
      MessageModal m1, int newIndex, int oldIndex) async {
    dataRepository.reorderMessages(m1, newIndex, oldIndex);
  }

  Future<void> reorderNotebook(Notebook nb, int newIndex, int oldIndex) async {
    dataRepository.reorderNotebooks(nb, newIndex, oldIndex);
  }

  Future<void> reorderNote(
      Note note, int newIndex, int oldIndex, String sectionId) async {
    dataRepository.reorderNotes(note, newIndex, oldIndex, sectionId);
  }

  Future<void> deleteMessage(MessageModal mm) async {
    dataRepository.deleteMessage(mm);
  }

  Future<List<Notebook>> getAllNotebooks() async {
    return await dataRepository.getAllNotebooks();
  }

  Future<void> deleteEntry(tableName, colName, whereColEqualTo) async {
    await dataRepository.deleteEntryInTable(
        tableName, colName, whereColEqualTo);
  }

  Future<List<Section>> getAllSections(notebookId) async {
    return await dataRepository.getAllSectionsOfNotebook(notebookId);
  }

  Future<void> createSection(Section sec) async {
    await dataRepository.createSectioninNoteBook(sec);
  }

  Future<List<Note>> getAllNotesBySection(String sectionId) async {
    return await dataRepository.getAllNotesBySection(sectionId);
  }

  Future<void> createNote(Note note) async {
    dataRepository.createNote(note);
  }

  //editing
  Future<void> editSection(Section section) async {
    await dataRepository.editSection(section);
  }

  Future<void> editNotebook(Notebook notebook) async {
    await dataRepository.editNotebook(notebook);
  }

  Future<void> editMessage(MessageModal message) async {
    await dataRepository.editMessage(message);
  }

  Future<void> deleteNotebook(Notebook notebook) async {
    await dataRepository.deleteNotebook(notebook);
  }

  Future<void> deleteSection(Section section) async {
    await dataRepository.deleteSection(section);
  }
}
