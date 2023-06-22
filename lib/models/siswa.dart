import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Siswa extends GetxController {
  @required
  String siswaId;
  @required
  String namaSiswa;
  @required
  RxString ketHadir = ''.obs;

  Siswa(
      {required this.siswaId, required this.namaSiswa, required this.ketHadir});
}
