import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class PimpinanController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var token;
  Future<String?> getMonitoringAkademik(hari, tanggal) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      // print(token);
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.getMonitoringAkademik);
      Map body = {'hari': hari.toString(), 'tanggal': tanggal.toString()};
      // print('controller $hari');
      // print('controller $tanggal');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      // print('response');
      dynamic formattedBody = json.decode(response.body);
      String prettyBody = JsonEncoder.withIndent('  ').convert(formattedBody);
      print(prettyBody);
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

  Future<String?> getMonitoringNonAkademik(hari, tanggal) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      // print(token);
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.getMonitoringNonAkademik);
      Map body = {'hari': hari.toString(), 'tanggal': tanggal.toString()};
      // print('controller $hari');
      // print('controller $tanggal');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      // print('response');
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

  Future<String?> getKelas() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getKelasAkademik);

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

  Future<String?> getKelasNonAkademik(angkatanId) async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.getKelasNonAkademik);

      Map body = {'angkatan': angkatanId};
      // print('controller $hari');
      // print('controller $tanggal');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
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

  Future<String?> getDetailAkademik(
      waktuMulai, waktuBerakhir, tanggal, hari, kelasId) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    print(waktuMulai);
    print(waktuBerakhir);
    print(tanggal);
    print(hari);
    print(kelasId);

    try {
      // print(token);
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.detailMonitoringAkademik);
      Map body = {
        'waktu_mulai': waktuMulai.toString(),
        'waktu_berakhir': waktuBerakhir.toString(),
        'tanggal': tanggal.toString(),
        'hari': hari.toString(),
        'kelas_id': kelasId.toString()
      };
      // print('controller $hari');
      // print('controller $tanggal');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print('response');
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

  Future<String?> getDetailNonAkademik(
      tanggal, hari, kelasId, kegiatanId) async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    print('controler');
    print(kegiatanId);
    print(hari);
    print(kelasId);
    print(tanggal);
    // print(waktuMulai);
    // print(waktuBerakhir);
    // print(tanggal);
    // print(hari);
    // print(kelasId);

    try {
      // print(token);
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.detailMonitoringNonAkademik);
      Map body = {
        'tanggal': tanggal.toString(),
        'hari': hari.toString(),
        'kelas_id': kelasId.toString(),
        'kegiatan_id': kegiatanId.toString()
      };
      // print('controller $hari');
      // print('controller $tanggal');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      // print('response');
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
}
