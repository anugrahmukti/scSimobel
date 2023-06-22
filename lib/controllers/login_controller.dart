import 'dart:convert';
import 'package:simobel/controllers/guru_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> login() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.login);
      Map body = {
        'username': usernameController.text.trim(),
        'password': passwordController.text.trim()
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
      //cek apakah request berhasil
      if (response.statusCode == 200) {
        //ambil isi request

        final json = jsonDecode(response.body);

        if (json['message'] == 'Login success') {
          var token = json['access_token'];
          var role = json['role'];

          if (role == 'guru' || role == 'pimpinan') {
            var namaGuru = json['user']['nama'];
            var hariPiket;
            var waktuPiket;
            if (json['jadwalPiket'] == '-') {
              hariPiket = '-';
              waktuPiket = '-';
            } else {
              hariPiket = json['jadwalPiket']['hari'];
              waktuPiket = json['jadwalPiket']['waktu_mulai']
                      .toString()
                      .substring(0, 5) +
                  '-' +
                  json['jadwalPiket']['waktu_berakhir']
                      .toString()
                      .substring(0, 5);
            }

            var pimpinan = json['pimpinan'];
            var username = json['username'];

            final SharedPreferences prefs = await _prefs;
            await prefs.setString('token', token);
            await prefs.setString('namaGuru', namaGuru);
            await prefs.setString('hariPiket', hariPiket);
            await prefs.setString('waktuPiket', waktuPiket);
            await prefs.setString('username', username);
            await prefs.setString('pimpinan', pimpinan);

            print(json['jadwalPiket']);

            if (pimpinan == '1') {
              print('pimpinan');
              Get.defaultDialog(
                radius: 4,
                title: 'Pilih Role Terlebih Dahulu',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                //     content: AlertDialog(
                //   title: Text('Pilih Role Terlebih Dahulu'),
                content: Column(children: [
                  SizedBox(
                    height: 40,
                    width: 240,
                    child: ElevatedButton(
                        onPressed: () async {
                          GuruController().updateRolePimpinan('pimpinan');
                          await prefs.setString('role', 'pimpinan');
                          Get.back();
                          Get.off(() => const Dashboard());
                        },
                        child: const Text('Login Sebagai Pimpinan')),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 40,
                    width: 240,
                    child: ElevatedButton(
                        onPressed: () async {
                          GuruController().updateRolePimpinan('guru');
                          await prefs.setString('role', 'guru');
                          Get.back();
                          Get.off(() => const Dashboard());
                        },
                        child: const Text('Login Sebagai Guru')),
                  )
                ]),
                // )
              );
              usernameController.clear();
              passwordController.clear();
            } else {
              await prefs.setString('role', 'guru');
              usernameController.clear();
              passwordController.clear();
              Get.off(() => const Dashboard());
            }
          } else if (role == 'siswa') {
            var namaSiswa = json['nama'];
            var kelas = json['kelas'];
            var username = json['username'];
            final SharedPreferences prefs = await _prefs;
            await prefs.setString('token', token);
            await prefs.setString('namaSiswa', namaSiswa);
            await prefs.setString('role', role);
            await prefs.setString('kelas', kelas);
            await prefs.setString('username', username);

            usernameController.clear();
            passwordController.clear();
            Get.off(() => const Dashboard());
          } else if (role == 'wali_asrama') {
            var namaWali = json['nama'];
            var angkatan = json['angkatan'];
            var angkatanId = json['angkatan_id'].toString();
            var username = json['username'];
            final SharedPreferences prefs = await _prefs;
            await prefs.setString('token', token);
            await prefs.setString('namaWali', namaWali);
            await prefs.setString('role', role);
            await prefs.setString('angkatan', angkatan);
            await prefs.setString('angkatan_id', angkatanId);
            await prefs.setString('username', username);

            usernameController.clear();
            passwordController.clear();
            Get.off(() => const Dashboard());
          }
          print(response.body);
        }
      } else if (response.statusCode == 500) {
        print(response.body);
      } else {
        throw jsonDecode(response.body)["Message"] ??
            "Username atau Password salah !";
      }
    } catch (error) {
      Get.defaultDialog(
        radius: 4,
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        title: "Pemberitahuan",
        titleStyle: TextStyle(fontWeight: FontWeight.bold),
        middleText: error.toString(),
        confirm: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("OK"),
        ),
      );
    }
  }
}
