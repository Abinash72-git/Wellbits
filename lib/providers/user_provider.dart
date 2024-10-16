import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wellbits/services/device_info.dart';
import 'package:wellbits/util/global.dart';

class UserProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isAuthorized = true;

  Future<void> initialFetch() async {
    AppGlobal.deviceInfo = await DeviceInfoServices.getDeviceInfo();
     
  }

  // Future getAgendaFilter({required String imei, required String clubID}) async {
  //   print(
  //       "${AppConstants.BASE_URL}${ApiKeyConstants.getagendafilter}?imei=$imei&club_id=$clubID");
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {
  //     "Authorization": sharedPrefs.getString(AppConstants.TOKEN).toString(),
  //     'Charset': 'utf-8',
  //     'Accept': 'application/json',
  //   };
  //   http.Response response = await http
  //       .get(
  //           Uri.parse(
  //               "${AppConstants.BASE_URL}${ApiKeyConstants.getagendafilter}?imei=$imei&club_id=$clubID"),
  //           headers: headers)
  //       .timeout(const Duration(seconds: 60));
  //   print(response.body);
  //   notifyListeners();
  //   var data = json.decode(response.body);
  //   return response.statusCode == 200
  //       ? AgendaFilterModel.fromMap(data)
  //       : <AgendaFilterModel>[];
  // }
}
