import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class WaliAsramaController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var token;
  Future<String?> getJadwal() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.jadwalWaliAsrama);

      http.Response response = await http.get(url, headers: headers);

      // print(response.body);
      dynamic formattedBody = json.decode(response.body);
      String prettyBody = JsonEncoder.withIndent('  ').convert(formattedBody);
      debugPrint(prettyBody);

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

  Future<String?> getKelas() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getKelasWasrama);

      http.Response response = await http.get(url, headers: headers);
      // print(response.body);
      // dynamic formattedBody = json.decode(response.body);
      // String prettyBody = JsonEncoder.withIndent('  ').convert(formattedBody);
      // print(prettyBody);

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

  Future<String?> getSiswaAsrama(jadwalId, kelasId, kegiatanId) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    // print('Ini tando get siswa');
    // print(jadwalId);
    // print(kelasId);
    // print(kegiatanId);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getSiswaAsrama);
      Map body = {
        'kelas_id': kelasId,
        'kegiatan_id': kegiatanId,
        'jadwal_id': jadwalId
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      dynamic formattedBody = json.decode(response.body);
      String prettyBody = JsonEncoder.withIndent('  ').convert(formattedBody);
      debugPrint(prettyBody);
      // var test = jsonDecode(response.body);
      // print(test['presensi']['50']);

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

  Future<String?> inputPresKegTanpaNara(
      jamDiMulai, jamBerakhir, jadwalId, presensi) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };

    // print(presensi.toString());
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.inputPresKegTanpaNara);
      Map body = {
        'presensi': presensi.toString(),
        'jamDimulai': jamDiMulai,
        'jamBerakhir': jamBerakhir,
        'jadwalId': jadwalId,
      };
      // ignore: unused_local_variable
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      // print(response.body);

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

  Future<String?> inputPresKegNara(
      jamDiMulai, jamBerakhir, jadwalId, presensi, narasumberId, topik) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };

    // print(presensi.toString());
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.inputPresKegNara);
      Map body = {
        'presensi': presensi.toString(),
        'jamDimulai': jamDiMulai,
        'jamBerakhir': jamBerakhir,
        'jadwalId': jadwalId,
        'narasumberId': narasumberId,
        'topik': topik,
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

  Future<String?> getNarasumber() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getNarasumber);

      http.Response response = await http.get(url, headers: headers);

      // print(response.body);
      // dynamic formattedBody = json.decode(response.body);
      // String prettyBody = JsonEncoder.withIndent('  ').convert(formattedBody);
      // print(prettyBody);

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
