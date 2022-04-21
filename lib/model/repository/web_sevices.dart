import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:dio/dio.dart';

const _base = "https://script.google.com/macros/s/";

const _funcSheetLinkBase = _base +
    "AKfycbwd0Dn620WtM_yG9x7Mu4xiMcLzJbOQTGKDZIVAT_qCkthI5aIqBvBU4nM1qEAnPvY/exec";

class WebServices {
  final Dio _dio = Dio();

  String get _id => AdminDataBloc.admin.id;

  Future<String> createSpreadSheet(
      String groupName, List<String> emails, List<String> titles) async {
    String url = _funcSheetLinkBase +
        "?func=addsheet" +
        "&sheetName=$groupName" +
        "&viewersEmailsList=$emails" +
        "&columnsTitles=$titles";
    print(url);
    String id = await _doRequest(url);
    print(id);
    return id;
  }

  Future<void> deleteStudentFromSheet(int userIndex, int groupIndex) async {
    String url =
        "${_funcSheetLinkBase}fun=remove&group=$groupIndex&person_id=$userIndex&userName=$_id";
    await _doRequest(url);
  }

  Future<void> sendStudentNewData(
      int groupIndex, String id, Map dataToSent) async {
    String url = "${_funcSheetLinkBase}fun=edit"
        "&group=$groupIndex"
        "&user_data=$dataToSent"
        "&person_id=$id"
        "&userName=$_id";
    await _doRequest(url);
  }

  Future<Map<String, dynamic>> getUserData(
      int groupIndex, int userIndex) async {
    Map<String, dynamic> userData = {};
    String url = _funcSheetLinkBase +
        "userName=$_id"
            "&group=$groupIndex"
            "&index=${userIndex + 1}";
    userData = await _doRequest(url);
    if (userData.containsKey("imgUrl")) {
      userData['imgUrl'] = "https://drive.google.com/uc?export=view&id=" +
          userData['imgUrl'].split('/')[5];
    }
    return userData;
  }

  Future<GroupDetails> getGroupData(int index, GroupDetails details) async {
    String url = _funcSheetLinkBase +
        "userName=$_id"
            "&group=$index";
    print("start request");
    String data = await _doRequest(url);
    print("received $data");
    var list = data.split("!");
    details.studentNames = list[0].split(',');
    // details.columnNames = list[1].split(',');
    return details;
  }

  Future<bool> sendCredentialsToEsp(
      String wifiName, String wifiPassword) async {
    wifiPassword = _prepareCredentials(wifiPassword);
    wifiName = _prepareCredentials(wifiName);

    String url =
        'http://192.168.4.1/data?user=$_id&wifi=$wifiName&pass=$wifiPassword';
    print("url");
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
    try {
      Response response = await _dio.get(url);
      return response.data;
    } on DioError catch (e) {
      print("err $e");
      throw DioErrors.fromCode(e);
    } catch (_) {
      print("err $_");
      throw const DioErrors();
    }
  }

  String _prepareCredentials(String old) {
    Map<String, dynamic> changedData = {
      "#": "%23",
      "&": "%26",
      "\$": "%24",
      " ": "%20"
    };
    changedData.forEach((key, value) {
      old = old.replaceAll(key, value);
    });

    return old;
  }
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
