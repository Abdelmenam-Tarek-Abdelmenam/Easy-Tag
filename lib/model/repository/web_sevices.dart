import 'package:auto_id/model/module/group_details.dart';
import 'package:dio/dio.dart';

import '../module/students.dart';

const _base = "https://script.google.com/macros/s/";

const _testBase =
    "AKfycbwIpg5PuOvrUBcKWwXJJ6QqBXRgUzY4DTNRW_j5yEvulQay3-AmYQ4Tsts-Yu55OTU";

const _stableBase =
    "AKfycbyEazGuwCLyFwut7WXoDQqovSmpNeP_GesKoWXJbiLFxBepDYoPPTZiFQ3YsOaxnkI";

const _funcSheetLinkBase = _base + _stableBase + "/exec?";

class WebServices {
  final Dio _dio = Dio();

  Future<String> createSpreadSheet(
      String groupName, List<String> emails, List<String> titles) async {
    String url = _funcSheetLinkBase +
        "func=addsheet" +
        "&sheetName=$groupName" +
        "&viewersEmailsList=$emails" +
        "&columnsTitles=$titles";
    String id = await _doRequest(url);
    return id;
  }

  Future<GroupDetails> getGroupData(int index, GroupDetails details) async {
    String url = _funcSheetLinkBase +
        "func=get_all_users"
            "&sheetID=${details.id}";
    List<dynamic> data = await _doRequest(url);
    if (data.isEmpty) {
      details.students = [];
    } else {
      details.students = data.cast().map((e) => Student.fromJson(e)).toList();
    }
    return details;
  }

  Future<bool> deleteStudentFromSheet(String userId, String sheetId) async {
    String url = _funcSheetLinkBase +
        "func=delete_user" +
        "&sheetID=$sheetId" +
        "&uid=$userId";
    String response = await _doRequest(url);
    return response.trim() == "removed";
  }

  Future<bool> registerStudentAttendance(String userId, String sheetId) async {
    String url = _funcSheetLinkBase +
        "func=register" +
        "&sheetID=$sheetId" +
        "&uid=$userId";
    String response = await _doRequest(url);
    return response.trim() == "Done";
  }

  Future<bool> saveUserScore({
    required String userId,
    required String sheetId,
    required String quizId,
    required int score,
    required int len,
    required int time,
  }) async {
    String url = _funcSheetLinkBase +
        "func=add_result" +
        "&quiz_id=$quizId" +
        "&marks=$score,$len,$time" +
        "&sheetID=$sheetId" +
        "&uid=$userId";
    String response = await _doRequest(url);
    return response.trim() == "Done";
  }

  Future<Student> getUserData(String userId, String sheetId) async {
    Map<String, dynamic> userData = {};
    String url = _funcSheetLinkBase +
        "func=get_user" +
        "&sheetID=$sheetId" +
        "&uid=$userId";
    userData = await _doRequest(url);

    return Student.fromJson(userData);
  }

  Future<bool> sendStudentNewData(String groupId, Map dataToSent) async {
    String url = _funcSheetLinkBase +
        "func=adduser"
            "&sheetID=$groupId"
            "&userData=$dataToSent";
    String response = await _doRequest(url);
    return response.trim() == "Done,0";
  }

  Future<bool> editStudentData(String groupId, Map dataToSent) async {
    String url = _funcSheetLinkBase +
        "func=edit_user"
            "&sheetID=$groupId"
            "&userData=$dataToSent"
            "&uid=${dataToSent['UID']}";
    String response = await _doRequest(url);
    return response.trim() == "Done,0";
  }

  Future<bool> sendCredentialsToEsp(
      String wifiName, String wifiPassword) async {
    // wifiPassword = (wifiPassword);
    // wifiName = (wifiName);

    String url = 'http://192.168.4.1/data?user=jCekYTPEXmMD7XJWlJdPPtrLBED2'
        '&wifi=$wifiName&pass=$wifiPassword';
    try {
      String response = await _doRequest(url);
      if (response.trim() != "Failed") {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<dynamic> _doRequest(String url) async {
    print(url);
    try {
      Response response = await _dio.get(url);
      return response.data;
    } on DioError catch (e) {
      throw DioErrors.fromCode(e);
    } catch (e) {
      throw const DioErrors();
    }
  }

  // String _prepareCredentials(String old) {
  //   Map<String, dynamic> changedData = {
  //     "#": "%23",
  //     "&": "%26",
  //     "\$": "%24",
  //     " ": "%20"
  //   };
  //   changedData.forEach((key, value) {
  //     old = old.replaceAll(key, value);
  //   });
  //
  //   return old;
  // }
}

class DioErrors implements Exception {
  const DioErrors([
    this.message = 'An unknown exception occurred.',
  ]);

  factory DioErrors.fromCode(DioError error) {
    String message;
    switch (error.type) {
      case DioErrorType.connectTimeout:
        message = 'server not reachable';
        break;
      case DioErrorType.sendTimeout:
        message = 'send Time out';
        break;
      case DioErrorType.receiveTimeout:
        message = 'server not reachable';
        break;
      case DioErrorType.response:
        message = 'the server response, but with a incorrect status';
        break;
      case DioErrorType.cancel:
        message = 'request is cancelled';
        break;
      case DioErrorType.other:
        error.message.contains('SocketException')
            ? message = 'check your internet connection'
            : message = "Unknown error happened";
        break;
    }
    return DioErrors(message);
  }

  final String message;
}
