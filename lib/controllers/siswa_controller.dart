import 'dart:convert';
import 'package:get/get.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SiswaController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var token;
  Future<String?> getKegiatan(hari, tanggal) async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    print('controller1 $tanggal');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.kegiatanSiswa);
      Map body = {'hari': hari, 'tanggal': tanggal};
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

  Future<String?> getKegiatanNonAkademik(hari, tanggal) async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');

    print('controller2 $tanggal');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.kegiatanNonAkademik);
      Map body = {'hari': hari, 'tanggal': tanggal};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print('ini print respon body');
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
}
