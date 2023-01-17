import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseManagementHelper {
  static deleteTable(Database db, String tableName) async {
    await db.execute("DROP TABLE IF EXISTS $tableName");
  }

  static createTable(Database db, String tableConfiguration) async {
    try {
      await db.execute(tableConfiguration);
      debugPrint(
          "Table Created with following configuration: \n$tableConfiguration");
    } catch (e) {
      debugPrint("Error in createTable: ${e.toString()}");
    }
  }

  static deleteEntry(Database db, String tableName, String colName,
      String whereColEqualTo) async {
    int count = await db.rawDelete(
        'DELETE FROM $tableName WHERE $colName = ?', [whereColEqualTo]);
    assert(count == 1);
  }

  static printTable(Database db, String tableName, String whereCol,
      String whereColEqualsToString) async {
    List<Map> maps = await db.query(tableName,
        where: '$whereCol = ?', whereArgs: [whereColEqualsToString]);

    debugPrint(maps.toString());
  }

  //creae table to store important data using username as primary key
  static Future<void> createTableToStoreMessages(
      {db,
      messagesTable,
      pageID,
      colActualMessage,
      colMessageType,
      colMessageDate,
      colMessageTime}) async {
    try {
      await db.execute("""CREATE TABLE $messagesTable($pageID TEXT, 
          $colActualMessage TEXT, $colMessageType TEXT, $colMessageDate TEXT,
           $colMessageTime TEXT  PRIMARY KEY)""");
    } catch (e) {
      debugPrint("Error in createTableToStoreMessages: ${e.toString()}");
    }
  }

  static Future<void> createTableToStoreNotebooks({
    db,
    booksTable,
    notebookId,
    colNotebookTitle,
    colNotebookBody,
    colNotebookSections,
  }) async {
    try {
      await db.execute(
          """CREATE TABLE $booksTable($notebookId TEXT PRIMARY KEY, $colNotebookTitle TEXT, $colNotebookBody TEXT, $colNotebookSections TEXT)""");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
