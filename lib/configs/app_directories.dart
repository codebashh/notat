import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDirectories {
  static Directory? databaseDirectory;
  static Directory? imagesDirectory;
  static Directory? videosDirectory;
  static Directory? audiosDirectory;
  static Directory? thumbnailDirectory;
  static Future<void> init() async{
     await initAllDirectories();
  }

  static Future<void> initAllDirectories() async {
    String desiredPath = '';
    if (Platform.isAndroid) {
      // Get the directory path to store the database
      desiredPath = await getDatabasesPath();
    }
    if (Platform.isIOS) {
      Directory? directory = await getLibraryDirectory();
      desiredPath = directory.path;
    }

    //creates a hidden folder for the databases
    databaseDirectory = Directory('$desiredPath/.Databases/');
    imagesDirectory = Directory('$desiredPath/.Images/');
    videosDirectory = Directory('$desiredPath/.Videos/');
    audiosDirectory = Directory('$desiredPath/.Audios/');
    thumbnailDirectory = Directory('$desiredPath/.Thumbnails/');
    if (!(await databaseDirectory!.exists())) {
      await databaseDirectory!.create();
    }
    if (!(await imagesDirectory!.exists())) {
      await imagesDirectory!.create();
    }
    if (!(await videosDirectory!.exists())) {
      await videosDirectory!.create();
    }
    if (!(await audiosDirectory!.exists())) {
      await audiosDirectory!.create();
    }
    if (!(await thumbnailDirectory!.exists())) {
      await thumbnailDirectory!.create();
    }
  }

  
}
