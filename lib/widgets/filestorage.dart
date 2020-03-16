import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/categories.json');
  }

  Future<String> readJsonCategories() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeJsonCategories(String jsonString) async {
    final file = await _localFile;

    return file.writeAsString(jsonString);
  }
}