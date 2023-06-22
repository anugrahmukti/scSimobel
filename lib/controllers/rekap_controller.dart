import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/utils/api_endpoints.dart';

class RekapController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> download(url) async {
    final SharedPreferences prefs = await _prefs;
    dynamic token = prefs.get('token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    var status = await Permission.storage.request();
    if (status.isGranted) {
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }

      String downloadPath = directory!.path;
      Directory(downloadPath).createSync(recursive: true);

      try {
        await FlutterDownloader.enqueue(
          headers: headers,
          url: url,
          savedDir: downloadPath,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true,
        ).then((taskId) async {
          if (taskId != null) {
            final savedDir = Directory(downloadPath);
            final files = await savedDir.list().toList();
            FileSystemEntity? downloadedFile;
            try {
              downloadedFile = files.firstWhere(
                (file) {
                  return file.path.endsWith('.xlsx');
                },
              );
            } catch (e) {
              downloadedFile = null;
            }

            const AndroidNotificationDetails androidPlatformChannelSpecifics =
                AndroidNotificationDetails(
              'download_channel_id',
              'Download Channel',
              channelDescription: 'Channel for file download notifications',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              enableLights: true,
            );
            const NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);

            if (downloadedFile != null) {
              await flutterLocalNotificationsPlugin.show(
                0,
                'Download Berhasil',
                'File berhasil didownload',
                platformChannelSpecifics,
              );
            } else {
              await flutterLocalNotificationsPlugin.show(
                0,
                'Download Gagal',
                'File gagal didownload',
                platformChannelSpecifics,
              );
            }
          } else {
            Get.snackbar(
              'Download Gagal',
              'File gagal didownload',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
            );
          }
        });
      } on FlutterDownloaderException catch (error) {
        print(error.message);
      }
    }
  }

  Future<void> downloadRekapKehadiranSiswaPimpinan(
      kelas, tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getRekapKehadiranPembelajaran +
        '/' +
        kelas +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapKeterlaksanaanGuru(
      tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getKeterlaksanaanGuru +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapDaftarPertemuanGuru(
      kelas, mapel, tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getDaftarPertemuanGuru +
        '/' +
        kelas +
        '/' +
        mapel +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapDPKpimpinan(
      kegiatan, angkatan, tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getDPKpimpnan +
        '/' +
        kegiatan +
        '/' +
        angkatan +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapKSKpimpinan(
      kegiatan, kelas, tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getKSKpimpinan +
        '/' +
        kegiatan +
        '/' +
        kelas +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapWaliAsrama(
      kegiatan, tanggalAwal, tanggalAkhir) async {
    final SharedPreferences? prefs = await _prefs;

    var angkatanId = prefs?.get('angkatan_id');

    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getRekapWaliAsrama +
        '/' +
        kegiatan +
        '/' +
        angkatanId.toString() +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapPembelajaranSiswa(tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getRekapPembelajaranSiswa +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }

  Future<void> downloadRekapKegiatanSiswa(
      kegiatan, tanggalAwal, tanggalAkhir) async {
    var url = ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.getRekapKegiatanSiswa +
        '/' +
        kegiatan +
        '/' +
        tanggalAwal +
        '/' +
        tanggalAkhir;
    print(url);

    download(url);
  }
}
