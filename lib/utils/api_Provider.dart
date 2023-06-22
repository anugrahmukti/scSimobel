import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String apiUrl;

  ApiProvider({required this.apiUrl});
  Future<dynamic> fetchData() async {
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    late final dynamic $token;
    final SharedPreferences prefs = await prefs0;
    $token = prefs.get('token');
    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + $token,
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // print(jsonData);
      return jsonData['kelas'];
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<dynamic> fetchKegiatan() async {
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    late final dynamic $token;
    final SharedPreferences prefs = await prefs0;
    $token = prefs.get('token');
    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + $token,
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // print(jsonData);
      return jsonData['kegiatan'];
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<dynamic> fetchAngkatan() async {
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    late final dynamic $token;
    final SharedPreferences prefs = await prefs0;
    $token = prefs.get('token');
    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + $token,
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // print(jsonData);
      return jsonData['angkatan'];
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<dynamic> fetchDataMapel() async {
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    dynamic $token;
    final SharedPreferences prefs = await prefs0;
    $token = prefs.get('token');
    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + $token,
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // print(jsonData);
      return jsonData['mapel'];
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}
