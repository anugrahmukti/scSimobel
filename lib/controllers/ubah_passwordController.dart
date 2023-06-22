import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class UbahPasswordController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> ubahPasssword(username, password) async {
    final SharedPreferences? prefs = await _prefs;
    dynamic token = prefs?.get('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    try {
      print(username);
      print(password);
      Map body = {'username': username, 'password': password};

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.ubahPassword);
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
      // MaterialPageRoute(builder: (context) => AuthScreen());
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json['username']);
        final SharedPreferences prefs = await _prefs;
        await prefs.setString('username', json['username']);
        Get.defaultDialog(
          radius: 4,
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          title: "Pemberitahuan",
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
          middleText: 'Username dan Password berhasil di perbarui',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK"),
          ),
        );
      } else {
        throw jsonDecode(response.body)["Message"] ??
            Get.defaultDialog(
              radius: 4,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              title: "Pemberitahuan",
              titleStyle: TextStyle(fontWeight: FontWeight.bold),
              middleText: 'Username dan Password gagal di perbarui',
              confirm: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("OK"),
              ),
            );
      }
    } catch (error) {
      Get.back();
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
