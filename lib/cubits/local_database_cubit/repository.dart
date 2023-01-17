part of 'cubit.dart';

class LocalDatabaseRepository {
  late LocalDatabaseDataProvider dataProvider;
  LocalDatabaseRepository() {
    dataProvider = LocalDatabaseDataProvider();
  }
  Future<void> initDirectoriesAndDatabase() async {
    await AppDirectories.init();
    await initDatebase();
  }

  Future<void> initDatebase() => LocalDatabaseDataProvider.initializeDatabase();

  Future<void> insertMessage(MessageModal message) async {
    await dataProvider.insertMessageInMessagesTable(message: message);
  }

  Future<List<MessageModal>> getPageMessages(String pageID) async {
    return await dataProvider.getPageMessages(pageID);
  }

  Future<void> printMessageTable(
      String tableName, String whereCol, String whereColEqualsToString) async {
    dataProvider.printTable(
        tableName: tableName,
        whereCol: whereCol,
        whereColEqualsToString: whereColEqualsToString);
  }

  Future<void> createTable(String tableConfiguration) async {
    dataProvider.createTable(tableConfiguration);
  }

  Future<void> reorderMessages(
      MessageModal m1, int newIndex, int oldIndex) async {
    dataProvider.reorderRowsInDatabase(m1, newIndex, oldIndex);
  }

  Future<void> reorderNotebooks(Notebook n1, int newIndex, int oldIndex) async {
    await dataProvider.reorderNotebooksRowsInDatabase(n1, newIndex, oldIndex);
  }

  Future<void> reorderNotes(
      Note note, int newIndex, int oldIndex, String sectionId) async {
    await dataProvider.reorderNotesRowsInDatabase(
        sectionId, note, newIndex, oldIndex);
  }

  Future<void> deleteMessage(MessageModal mm) async {
    dataProvider.deleteEntry(
        '__Messages_table', 'messageTime', mm.messageTime!);
  }

  Future<List<Notebook>> getAllNotebooks() async {
    return await dataProvider.getAllNoteBooks();
  }

  Future<void> createNotebook(Notebook nb) async {
    await dataProvider.createNotebook(nb: nb);
  }

  Future<void> deleteEntryInTable(tableName, colName, whereColEqualTo) async {
    await dataProvider.deleteEntry(tableName, colName, whereColEqualTo);
  }

  Future<List<Section>> getAllSectionsOfNotebook(noteBookId) async {
    return await dataProvider.getAllSectionsOfNoteBook(noteBookId);
  }

  Future<void> createSectioninNoteBook(Section sec) async {
    await dataProvider.createSectioninNoteBook(sec);
  }

  Future<List<Note>> getAllNotesBySection(sectionId) async {
    return await dataProvider.getAllNotesBySection(sectionId);
  }

  Future<void> createNote(Note note) async {
    dataProvider.createNote(note);
  }

  Future<void> editSection(Section section) async {
    await dataProvider.editSection(section);
  }

  Future<void> editNotebook(Notebook notebook) async {
    await dataProvider.editNoteBook(notebook);
  }

  Future<void> editMessage(MessageModal message) async {
    await dataProvider.editMessage(message);
  }

  Future<void> deleteNotebook(Notebook notebook) async {
    dataProvider.deleteEntry('__Books_table', 'id', notebook.id);
  }

  Future<void> deleteSection(Section section) async {
    dataProvider.deleteEntry('__Sections_table', 'id', section.id);
  }
}
