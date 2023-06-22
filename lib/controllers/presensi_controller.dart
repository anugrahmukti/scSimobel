import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PresensiController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  dynamic token;
  Future<String?> getSiswa(kelasId) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.siswa);
      Map body = {
        'kelas_id': kelasId,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Data Gagal di Ambil !";
      }
    } catch (error) {
      return jsonDecode("{'message':'erorr'}");
    }
  }

  Future<String?> inputPresensi(
      jamDiMulai, jamBerakhir, jadwalId, presensi, agendaBelajar) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    var now = DateTime.now();
    String tanggal = DateFormat('yyyy-MM-dd', "id_ID").format(now);

    // print(presensi.toString());
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.presensiPembelajaran);
      Map body = {
        'presensi': presensi.toString(),
        'jamDimulai': jamDiMulai,
        'jamBerakhir': jamBerakhir,
        'jadwalId': jadwalId,
        'agendaBelajar': agendaBelajar,
        'tanggal': tanggal
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
    } catch (error) {
      return jsonDecode("{'message':'erorr'}");
    }
    return null;
  }

  Future<String?> inputPresensiTidakValid(
      jadwalID, ketGuru, agendaBelajar, presensi) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    print('masuk sini');
    print(jadwalID);
    print(ketGuru);
    print(agendaBelajar);
    print(presensi);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };

    // print(presensi.toString());
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.tidakValid);
      Map body = {
        'presensi': presensi.toString(),
        'jadwal_id': jadwalID,
        'keterangan': ketGuru,
        'topik': agendaBelajar,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);

      // //cek apakah request berhasil
      // if (response.statusCode == 200) {
      //   return  response.body;
      // } else {

      //   throw jsonDecode(response.body)["Message"] ??
      //       "Data Gagal di Ambil !";
      // }
    } catch (error) {
      return jsonDecode("{'message':'erorr'}");
    }
    return null;
  }
}
