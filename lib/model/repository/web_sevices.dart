import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:dio/dio.dart';

const _base = "https://script.google.com/macros/s/";

const _funcSheetLinkBase = _base +
    "AKfycbxx3WO2ZZQ0jSInhHwsl6p3ZvnM4NAVP-ka0ecbqkZJRnOlj8G7qTyvZcZdknsQGvk/exec?";
const _dataSheetLinkBase = _base +
    "AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?";
const _infoSheetLinkBase = _base +
    "AKfycbwCgPd0uvbcYCrn3D5v-4GsH_E9OhMUakXe2D3tY0phqN3nxivfWn3efJ4TE6ckqgXa/exec?";
const _setSheetDataLink = _base +
    "AKfycbyDVddZV5IbMoj93yxZKY7tPdcyxG7pqjq5wkNTOxPHAKUsLZdvZoWZsjfmCJbhhO6NHA/exec?";
const _createSheetLinkBase = _base +
    "AKfycbz3o9eqSWAGqFUf1C2Vk1waU6DgaqyVUjPtSyz9rw8ZQ-o_8U_aAwnnCaunX1Heo3Vn/exec?";
const _testSheetLinkBase = _base +
    "AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?";

class WebServices {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://script.google.com",
    connectTimeout: 2000,
    receiveTimeout: 3000,
  ));

  String get _id => AdminDataBloc.admin.id;

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
    String url = _dataSheetLinkBase +
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
    String url = _infoSheetLinkBase +
        "userName=$_id"
            "&group=$index";
    print("start requset");
    String data = await _doRequest(url);
    print("recieved $data");
    var list = data.split("!");
    details.studentNames = list[0].split(',');
    details.columnNames = list[1].split(',');
    return details;
  }

  Future<bool> addColumnNames(
      String id, String groupName, List<String> renameRowsName) async {
    String url = _setSheetDataLink + "id=" + id + "&list=$renameRowsName";
    String returned = (await _doRequest(url)).toString();
    return returned.trim() == "1";
  }

  Future<String> createSpreadSheet(String groupName) async {
    String url = _createSheetLinkBase + "name=$_id $groupName";
    String id = await _doRequest(url);
    return id;
  }

  Future<dynamic> testSheetLink(String groupName, String link) async {
    String id = link.split('/')[5];
    var url = _testSheetLinkBase + "id=$id";
    return await _doRequest(url);
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
      print("err");
      throw DioErrors.fromCode(e);
    } catch (_) {
      print("err");
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
