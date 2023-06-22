import 'dart:convert';
import 'package:simobel/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var token;
  Future<void> logout() async {
    final SharedPreferences? prefs = await _prefs;
    token = prefs?.get('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.logout);
      http.Response response = await http.get(url, headers: headers);
      // print(response.body);
      // MaterialPageRoute(builder: (context) => AuthScreen());
      if (response.statusCode == 200) {
        prefs?.clear();
        Get.back();
        Get.off(() => const AuthScreen());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Logout Gagal !";
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Logout Gagal'),
              contentPadding: EdgeInsets.all(20),
              children: [Text('Coba lagi')],
            );
          });
    }
  }
}
