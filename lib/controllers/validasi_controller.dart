import 'dart:convert';
import 'package:get/get.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class validasiController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var token;
  Future<String?> getValidasi() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.validasi);

      http.Response response = await http.get(url, headers: headers);
      // print(response.body);

      //cek apakah request berhasil
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Data Gagal di Ambil !";
      }
    } catch (error) {
      return jsonDecode("{'message':'erorr'}");
    }
  }

  Future<String> valid(monitoringId) async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    print(monitoringId);
    // return '';
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.valid);
      Map body = {'monitoring_id': monitoringId};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);

      //cek apakah request berhasil
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Data Gagal di Ambil !";
      }
    } catch (error) {
      return jsonDecode("{'message':'erorr'}");
    }
  }

  Future<String> tidakValid() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.tidakValid);
      Map body = {};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      // print(response.body);

      //cek apakah request berhasil
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Data Gagal di Ambil !";
      }
    } catch (error) {
      return jsonDecode("{'message':'erorr'}");
    }
  }
}
