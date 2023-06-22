// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/siswa_controller.dart';
import 'package:simobel/screens/auth/widgets/jadwal_kegiatan.dart';

class ItemNonAkademik extends StatelessWidget {
  final List<String> hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu'
  ];
  final SiswaController siswaController = Get.put(SiswaController());

  @override
  Widget build(BuildContext context) {
    DateTime nows = DateTime.now();
    int weekday = nows.weekday;
    DateTime firstDayOfWeek = nows.subtract(Duration(days: weekday - 1));
    List<DateTime> datesOfWeek = [];
    for (int i = 0; i < 6; i++) {
      datesOfWeek.add(firstDayOfWeek.add(Duration(days: i)));
    }
    List<String> tanggals =
        datesOfWeek.map((date) => DateFormat('dd').format(date)).toList();

    // print(tanggals);
    var now = DateTime.now();
    String formatter = DateFormat('EEEE', "id_ID").format(now);
    var hariAktif = formatter.obs;
    String formater2 = DateFormat('y-MM-dd', "id_ID").format(now);
    var tanggalHariIni = formater2.obs;
    var tanggalIndex = DateFormat('dd', "id_ID").format(now);
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        // height: heightApp * 1,
        color: Colors.white,
        child: Column(
          children: [
            Container(
                // height: heightApp * 0.05,s
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: heightApp * 0.02),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Kegiatan Siswa",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )),
            SizedBox(
              height: heightApp * 0.075,
              width: widthApp * 0.95,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: hari.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: widthApp * 0.01,
                  );
                },
                itemBuilder: (context, index) {
                  var warnaTombol = const Color(0xffECEEF3);
                  var warnaTombolAktif = const Color(0xff1C67DC);
                  var warnaTextHitam = Colors.black;
                  var warnaTextPutih = Colors.white;
                  return Obx(() => GestureDetector(
                        onTapDown: (_) {
                          String formatTanggal = DateFormat('y-MM-', "id_ID")
                              .format(datesOfWeek[index]);

                          hariAktif.value = hari[index];
                          tanggalHariIni.value =
                              formatTanggal + tanggals[index];
                          tanggalIndex = tanggals[index];

                          print('=============$tanggalHariIni');
                        },
                        child: Container(
                          width: widthApp * 0.15,
                          // height: heightApp * 0.2,
                          decoration: BoxDecoration(
                              color: hariAktif.value == hari[index]
                                  ? warnaTombolAktif
                                  : warnaTombol,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                hari[index].toString().substring(0, 3),
                                style: TextStyle(
                                    color: hariAktif.value == hari[index]
                                        ? warnaTextPutih
                                        : warnaTextHitam,
                                    fontSize: 12),
                              ),
                              Text(tanggals[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hariAktif.value == hari[index]
                                        ? warnaTextPutih
                                        : warnaTextHitam,
                                  ))
                            ],
                          ),
                        ),
                      ));
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: heightApp * 0.01,
            ),
            // Container(
            //     padding: EdgeInsets.only(
            //       left: 20,
            //       top: 5,
            //     ),
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Jam",
            //       style: TextStyle(fontSize: 14),
            //     )),
            Obx(() => Container(
                  padding: EdgeInsets.only(top: 10),
                  child: FutureBuilder(
                      future: siswaController.getKegiatanNonAkademik(
                          hariAktif.toString(), tanggalHariIni.value),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: heightApp * 0.6,
                            child: Center(
                              heightFactor: 1,
                              child: SizedBox(
                                height: heightApp * 0.05,
                                child: const LoadingIndicator(
                                  indicatorType: Indicator.ballSpinFadeLoader,
                                  strokeWidth: 0.1,
                                  colors: [
                                    Color.fromARGB(255, 33, 86, 243),
                                    Colors.red,
                                    Color.fromARGB(255, 216, 142, 23),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        // print("ini print snapshot");

                        if (snapshot.hasData) {
                          var data = jsonDecode(snapshot.data);

                          if (data['jadwal-kegiatan'].length == 0) {
                            return Text(
                              "Tidak Ada Kegiatan",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black45),
                            );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: heightApp * 0.6,
                                  width: widthApp * 0.95,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: data['jadwal-kegiatan'].length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 0,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      var data1 =
                                          data['jadwal-kegiatan'][index];
                                      var jamDiMulai = data1['waktu_mulai']
                                          .toString()
                                          .substring(0, 5);

                                      var jamBerakhir = data1['waktu_berakhir'];
                                      var kegiatan = data1['kegiatan']['nama'];
                                      var jadwalID = data1['id'];

                                      var tanggalBaru =
                                          DateTime.parse(tanggalHariIni.value);
                                      print('############$tanggalBaru');
                                      String formatjam =
                                          DateFormat(' MMMM y', "id_ID")
                                              .format(tanggalBaru);
                                      var tanggalKegiatan =
                                          tanggalIndex + formatjam;

                                      print(
                                          '------------------$tanggalKegiatan');
                                      dynamic data2;
                                      var statusKehadiran = 'Belum Terlaksana';
                                      var topik = '';
                                      dynamic narasumber;
                                      if (data1['kegiatan']['narasumber'] ==
                                          '0') {
                                        data2 = data1['monitoring_kegiatan'];

                                        if (data2.length != 0) {
                                          statusKehadiran = data2[0]
                                                  ['kehadiran_kegiatan'][0]
                                              ['status'];
                                        }
                                        print('kegiatan $data2');
                                      } else {
                                        data2 = data1['monitoring_kegnas'];
                                        print('kegnas = $data2');
                                        if (data2.length != 0) {
                                          statusKehadiran = data2[0]
                                              ['kehadiran_kegnas'][0]['status'];
                                          topik = data2[0]['topik'];
                                          narasumber =
                                              data2[0]['narasumber']['nama'];
                                        }
                                      }

                                      // print(guruMapel);
                                      // print(topik);

                                      var indikatordataAwal = index;
                                      var indikatorDataAkhir =
                                          data['jadwal-kegiatan'].length;

                                      var hariAktifNow = hariAktif;

                                      return JadwalKegiatan(
                                          indikatordataAwal,
                                          indikatorDataAkhir,
                                          widthApp,
                                          jamDiMulai,
                                          jamBerakhir,
                                          kegiatan,
                                          jadwalID,
                                          hariAktifNow,
                                          tanggalKegiatan,
                                          statusKehadiran,
                                          narasumber,
                                          topik);
                                    },
                                    scrollDirection: Axis.vertical,
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return SizedBox(
                            height: heightApp * 0.55,
                            child: const Center(
                              child: Text(
                                "Periksa koneksi internet anda",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                          );
                        }
                      }),
                ))
          ],
        ),
      ),
    );
  }
}
