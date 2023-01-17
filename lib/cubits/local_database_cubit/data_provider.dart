part of 'cubit.dart';

class LocalDatabaseDataProvider {
// Tables
  static const String _booksTable = '__Books_table';
  static const String _sectionsTable = '__Sections_table';
  static const String _notesTable = '__Notes_Table';
  static const String _messagesTable = '__Messages_table';
// Database Columns for books Table
  static const String _notebookId = "id";
  static const String _colNotebookTitle = "title";
  static const String _colNotebookBody = "body";
  static const String _colNotebookSections = "sections";
// Database Columns for Sections Table
  static const String _sectionId = "id";
  static const String _secRefId = "reference";
  static const String _colSectionTitle = "title";
  static const String _colSectionBody = "body";
  static const String _colnotes = "notes";
// Database Columns For notes table

  static const String _notePageId = "id";
  static const String _noteRefId = "reference";
  static const String _colNotePageTitle = "title";
  static const String _colLabels = "labels";

// Database Columns For chat messages
  static const String _pageID = 'pageID';
  static const String _colActualMessage = 'actualMessage';
  static const String _colMessageType = 'messageType';
  static const String _colMessageDate = 'messageDate';
  static const String _colMessageTime = 'messageTime';

  static LocalDatabaseDataProvider _localStorageHelper =
      LocalDatabaseDataProvider._createInstance();
  static late Database _database;

  // Instantiate the obj
  LocalDatabaseDataProvider._createInstance(); //named constructor

  //For accessing the Singleton object
  factory LocalDatabaseDataProvider() {
    _localStorageHelper = LocalDatabaseDataProvider._createInstance();
    return _localStorageHelper;
  }

  //making a database
  static Future<void> initializeDatabase() async {
    try {
      Directory newDirectory = AppDirectories.databaseDirectory!;
      final String path = '${newDirectory.path}/NoteApp_local_storage.db';

      // create the database
      final Database getDatabase = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        LocalDatabaseManagementHelper.createTableToStoreMessages(
            db: db,
            colActualMessage: _colActualMessage,
            colMessageDate: _colMessageDate,
            colMessageTime: _colMessageTime,
            messagesTable: _messagesTable,
            colMessageType: _colMessageType,
            pageID: _pageID);

        LocalDatabaseManagementHelper.createTable(
            db, """CREATE TABLE $_booksTable($_notebookId TEXT PRIMARY KEY,
     $_colNotebookTitle TEXT, $_colNotebookBody TEXT, $_colNotebookSections TEXT)""");

        LocalDatabaseManagementHelper.createTable(
            db, """CREATE TABLE $_sectionsTable($_sectionId TEXT PRIMARY KEY,
     $_colSectionTitle TEXT, $_secRefId TEXT, $_colSectionBody TEXT, $_colnotes TEXT)""");
        LocalDatabaseManagementHelper.createTable(
            db, """CREATE TABLE $_notesTable($_notePageId TEXT PRIMARY KEY,
     $_colNotePageTitle TEXT, $_noteRefId TEXT, $_colLabels TEXT)""");
      });

      _database = getDatabase;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //get all prevoius messages for a particular connection
  Future<List<MessageModal>> getPageMessages(String pageID) async {
    try {
      List<Map<String, Object?>> rawData = await _database
          .query(_messagesTable, where: '$_pageID = ?', whereArgs: [pageID]);

      List<MessageModal> pageMessages = [];

      for (int i = 0; i < rawData.length; i++) {
        Map<String, dynamic> tempMap = rawData[i];
        pageMessages.add(MessageModal.fromMap(tempMap));
      }

      return pageMessages;
    } catch (e) {
      return [];
    }
  }

  Future<List<Notebook>> getAllNoteBooks() async {
    try {
      List<Map<String, Object?>> rawData = await _database.rawQuery(
        'SELECT * FROM $_booksTable',
      );

      List<Notebook> allBooks = [];
      for (int i = 0; i < rawData.length; i++) {
        Map<String, dynamic> tempMap = rawData[i];
        allBooks.add(Notebook.fromMap(tempMap));
      }

      return allBooks;
    } catch (e) {
      return [];
    }
  }

  //insert messages for page
  Future<void> insertMessageInMessagesTable(
      {required MessageModal message}) async {
    try {
      MessageModal mm = message;
      mm = await manageCache(message);

      Map<String, String> tempMap = mm.toMap();

      final int rowAffected = await _database.insert(_messagesTable, tempMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createNotebook({required Notebook nb}) async {
    try {
      Map<String, String> tempMap = nb.toMap();

      final int rowAffected = await _database.insert(_booksTable, tempMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> reorderRowsInDatabase(
      MessageModal m1, int newIndex, int oldIndex) async {
    try {
      List<Map<String, Object?>> readonlyData = await _database
          .query(_messagesTable, where: '$_pageID = ?', whereArgs: [m1.pageID]);

      List<Map<String, Object?>> maps = [];
      for (Map<String, Object?> element in readonlyData) {
        maps.add(Map<String, dynamic>.from(element));
      }
      maps = maps.reversed.toList();
      Map<String, Object?> toBeChanged = m1.toMap();

      maps.removeAt(oldIndex);

      maps.insert(newIndex, toBeChanged);
      maps = maps.reversed.toList();
      LocalDatabaseManagementHelper.deleteTable(_database, _messagesTable);
      LocalDatabaseManagementHelper.createTableToStoreMessages(
          db: _database,
          colActualMessage: _colActualMessage,
          colMessageDate: _colMessageDate,
          colMessageTime: _colMessageTime,
          messagesTable: _messagesTable,
          colMessageType: _colMessageType,
          pageID: _pageID);
      Batch batch = _database.batch();
      for (Map<String, Object?> item in maps) {
        batch.insert(_messagesTable, item);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> reorderNotebooksRowsInDatabase(
      Notebook nb, int newIndex, int oldIndex) async {
    try {
      List<Notebook> readonlyData = await getAllNoteBooks();
      List<Map<String, Object?>> maps = [];
      for (Notebook note in readonlyData) {
        maps.add(note.toMap());
      }

      maps = maps.reversed.toList();
      Map<String, Object?> toBeChanged = nb.toMap();
      maps.removeAt(oldIndex);

      maps.insert(newIndex, toBeChanged);
      maps = maps.reversed.toList();
      LocalDatabaseManagementHelper.deleteTable(_database, _booksTable);
      LocalDatabaseManagementHelper.createTableToStoreNotebooks(
        db: _database,
        booksTable: _booksTable,
        notebookId: _notebookId,
        colNotebookTitle: _colNotebookTitle,
        colNotebookBody: _colNotebookBody,
        colNotebookSections: _colNotebookSections,
      );
      Batch batch = _database.batch();
      for (Map<String, Object?> item in maps) {
        batch.insert(_booksTable, item);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> reorderNotesRowsInDatabase(
    String sectionId,
    Note note,
    int newIndex,
    int oldIndex,
  ) async {
    try {
      List<Note> readonlyData = await getAllNotesBySection(sectionId);
      List<Map<String, Object?>> maps = [];
      for (Note note1 in readonlyData) {
        maps.add(note1.toMap());
      }

      maps = maps.reversed.toList();
      Map<String, Object?> toBeChanged = note.toMap();
      maps.removeAt(oldIndex);

      maps.insert(newIndex, toBeChanged);
      maps = maps.reversed.toList();
      LocalDatabaseManagementHelper.deleteTable(_database, _notesTable);
      LocalDatabaseManagementHelper.createTable(
          _database, """CREATE TABLE $_notesTable($_notePageId TEXT PRIMARY KEY,
     $_colNotePageTitle TEXT, $_noteRefId TEXT, $_colLabels TEXT)""");
      Batch batch = _database.batch();
      for (Map<String, Object?> item in maps) {
        batch.insert(_notesTable, item);
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> printTable({tableName, whereCol, whereColEqualsToString}) async {
    LocalDatabaseManagementHelper.printTable(
        _database, tableName, whereCol, whereColEqualsToString);
  }

  Future<void> deleteTable(String tableName) async {
    LocalDatabaseManagementHelper.deleteTable(_database, tableName);
  }

  Future<void> createTable(String tableConfiguration) async {
    LocalDatabaseManagementHelper.createTable(_database, tableConfiguration);
  }

  Future<void> deleteEntry(
      String tableName, String colName, String whereColEqualTo) async {
    LocalDatabaseManagementHelper.deleteEntry(
        _database, tableName, colName, whereColEqualTo);
  }

  Future<MessageModal> manageCache(MessageModal message) async {
    switch (message.messageType) {
      case ChatMessageType.text:
        return message;
      case ChatMessageType.image:
        String path = AppDirectories.imagesDirectory!.path;
        File cachefile = File(message.actualMessage!);
        File actualfile =
            await cachefile.copy('$path${cachefile.path.split('/').last}');
        message = message.copyWith(actualMessage: actualfile.path);
        cachefile.delete();
        return message;
      case ChatMessageType.video:
        String path = AppDirectories.videosDirectory!.path;

        String thumbnailPath = AppDirectories.thumbnailDirectory!.path;
        String cacheFilePath = message.actualMessage!.split("data:")[1];
        File cachefile = File(cacheFilePath);
        String cacheThumbnailPath = message.actualMessage!.split("data:")[2];
        File cacheThumbanil = File(cacheThumbnailPath);
        File actualfile =
            await cachefile.copy('$path${cachefile.path.split('/').last}');
        File actualThumbanil = await cacheThumbanil
            .copy('$thumbnailPath${cacheThumbanil.path.split('/').last}');
        message = message.copyWith(
            actualMessage:
                "data:${actualfile.path}data:${actualThumbanil.path}");
        cachefile.delete();
        cacheThumbanil.delete();
        return message;

      case ChatMessageType.audio:
        return message;

      default:
        return message;
    }
  }

  Future<List<Section>> getAllSectionsOfNoteBook(noteBookId) async {
    try {
      List<Map<String, Object?>> rawData = await _database.query(_sectionsTable,
          where: '$_secRefId = ?', whereArgs: [noteBookId]);

      List<Section> sections = [];

      for (int i = 0; i < rawData.length; i++) {
        Map<String, dynamic> tempMap = rawData[i];
        sections.add(Section.fromMap(tempMap));
      }

      return sections;
    } catch (e) {
      return [];
    }
  }

  Future<void> createSectioninNoteBook(Section sec) async {
    try {
      Map<String, String> tempMap = sec.toMap();

      final int rowAffected = await _database.insert(_sectionsTable, tempMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Note>> getAllNotesBySection(String sectionId) async {
    try {
      List<Map<String, Object?>> rawData = await _database
          .query(_notesTable, where: '$_noteRefId = ?', whereArgs: [sectionId]);

      List<Note> notes = [];

      for (int i = 0; i < rawData.length; i++) {
        Map<String, dynamic> tempMap = rawData[i];
        notes.add(Note.fromMap(tempMap));
      }

      return notes;
    } catch (e) {
      return [];
    }
  }

  Future<void> createNote(Note note) async {
    try {
      Map<String, String> tempMap = note.toMap();

      final int rowAffected = await _database.insert(_notesTable, tempMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> editSection(Section section) async {
    try {
      Map<String, String> editSection = section.toMap();
      await _database.update(
        _sectionsTable,
        editSection,
        where: '$_sectionId = ?',
        whereArgs: [section.id],
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> editNoteBook(Notebook notebook) async {
    try {
      Map<String, String> newNotebook = notebook.toMap();
      await _database.update(
        _booksTable,
        newNotebook,
        where: '$_notebookId = ?',
        whereArgs: [notebook.id],
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> editMessage(MessageModal message) async {
    try {
      Map<String, String> newMessage = message.toMap();
      await _database.update(
        _messagesTable,
        newMessage,
        where: '$_pageID = ? AND $_colMessageTime = ?',
        whereArgs: [message.pageID, message.messageTime],
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
