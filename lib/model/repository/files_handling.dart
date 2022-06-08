import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../module/exam_question.dart';

const String _myDirectory = "EME Quizzes/";
const String _myExtension = "fl";

class DbFileHandling {
  Future<Quiz?> importQuiz() async {
    FilePickerResult? value = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [_myExtension],
        withData: true);
    if (value != null && value.files.isNotEmpty) {
      File file = File(value.files.first.path!);
      String data = file.readAsStringSync();
      Map<String, dynamic> dataMap = _decode(data);
      return Quiz.fromJson(dataMap);
    }
    return null;
  }

  Future<void> exportQuiz(Quiz quiz) async {
    File file = await _getNewFile('${quiz.title}.$_myExtension');
    String encoded = _encode(quiz.toJson);
    file.writeAsStringSync(encoded);
  }

  Future<File> _getNewFile(String fileName) async {
    if (await Permission.storage.request().isGranted) {
      String newPath = await _findPath();
      Directory dir = Directory(newPath);
      if (await dir.exists()) {
        File saveFile = File(newPath + fileName);
        return saveFile;
      } else {
        await Directory(newPath).create();
        File saveFile = File(newPath + fileName);
        return saveFile;
      }
    } else {
      throw Exception('Permission Denied');
    }
  }

  Future<String> _findPath() async {
    Directory? dir = await getExternalStorageDirectory();
    String newPath = "";
    List<String> folders = dir!.path.split("/");
    for (int x = 1; x < folders.length; x++) {
      if (folders[x] != 'Android') {
        newPath += "/" + folders[x];
      } else {
        break;
      }
    }
    newPath = newPath + "/$_myDirectory";
    return newPath;
  }

  String _encode(dynamic data) {
    String encoded = json.encode(data);
    final enCodedJson = utf8.encode(encoded);
    final gZipJson = gzip.encode(enCodedJson);
    String decodeData = base64.encode(gZipJson);
    return decodeData;
  }

  dynamic _decode(String old) {
    try {
      final decodeBase64Json = base64.decode(old);
      final decodeZipJson = gzip.decode(decodeBase64Json);
      String originalJson = utf8.decode(decodeZipJson);
      return json.decode(originalJson);
    } catch (err) {
      return "Wrong formatted";
    }
  }
}
