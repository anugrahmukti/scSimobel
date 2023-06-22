import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/siswa_controller.dart';
import 'package:simobel/screens/auth/widgets/jadwal_kegiatan.dart';

// ignore: must_be_immutable
class ItemAkademik extends StatelessWidget {
  late final DateTime now = DateTime.now();

  final SiswaController siswaController = Get.put(SiswaController());

  ItemAkademik({super.key});
  List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

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
    print('===========');
    print(datesOfWeek);
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
        // height: heightApp * 1.8,
        color: const Color(0xffF9FBFD),
        child: Column(
          children: [
            // Container(),
            Container(
                // height: heightApp * 0.05,
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
                          print(hariAktif);
                          String formatTanggal = DateFormat('y-MM-', "id_ID")
                              .format(datesOfWeek[index]);

                          hariAktif.value = hari[index];
                          tanggalHariIni.value =
                              formatTanggal + tanggals[index];
                          tanggalIndex = tanggals[index];
                          print('didalam ontap $tanggalIndex');
                          print('tanggal hari ini $tanggalHariIni.value');
                          print('hari aktif ontap$hariAktif');
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

            Obx(() => FutureBuilder(
                future: siswaController.getKegiatan(
                    hariAktif.toString(), tanggalHariIni.value),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: heightApp * 0.6,
                      child: Center(
                        heightFactor: 10,
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
                    if (hariAktif.value == 'Minggu') {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: heightApp * 0.2, bottom: heightApp * 0.4),
                        child: const Center(
                          child: Text(
                            "Hari Minggu",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                      );
                    }
                    var data = jsonDecode(snapshot.data);
                    int lengthJadwalPengganti;
                    if (data['jadwal-pengganti'].length == 0) {
                      lengthJadwalPengganti = 0;
                    } else {
                      lengthJadwalPengganti = data['jadwal-pengganti'].length;
                    }
                    // print('jadwal pengganti length');
                    // print(lengthJadwalPengganti);
                    if (data['jadwal-siswa'].length == 0) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: heightApp * 0.2, bottom: heightApp * 0.4),
                        child: const Text(
                          "Tidak Ada Kegiatan Pembelajaran",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black45),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          // Container(
                          //     // height: heightApp * 0.04,
                          //     padding: EdgeInsets.only(
                          //       left: widthApp * 0.05,
                          //       top: 5,
                          //     ),
                          //     alignment: Alignment.centerLeft,
                          //     child: const Text(
                          //       "Jam",
                          //       style: TextStyle(fontSize: 14),
                          //     )),
                          SizedBox(
                            // height: heightApp * 0.65,
                            width: widthApp * 0.95,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data['jadwal-siswa'].length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 0,
                                );
                              },
                              itemBuilder: (context, index) {
                                var data1 = data['jadwal-siswa'][index];
                                var jamDiMulai = data1['waktu_mulai']
                                    .toString()
                                    .substring(0, 5);

                                var jamBerakhir = data1['waktu_berakhir'];
                                var mapel = data1['mata_pelajaran']['nama'];
                                var jadwalID = data1['id'];
                                var tanggalBaru =
                                    DateTime.parse(tanggalHariIni.value);
                                String formatjam =
                                    DateFormat(' MMMM y', "id_ID")
                                        .format(tanggalBaru);
                                var tanggalKegiatan = tanggalIndex + formatjam;

                                print('^^^^^^^^^^^^$tanggalKegiatan');

                                var data2 = data1['monitoring_pembelajarans'];
                                var statusKehadiran = 'Belum Terlaksana';
                                var topik =
                                    'Agenda pembelajaran belum diinputkan';

                                if (data2.length != 0) {
                                  topik = data2[0]['topik'];
                                  if (data2[0]['kehadiran_pembelajarans']
                                          .length !=
                                      0) {
                                    // print('ada data');
                                    statusKehadiran = data2[0]
                                            ['kehadiran_pembelajarans'][0]
                                        ['status'];
                                  }
                                }
                                var guruMapel = data1['guru']['nama'];

                                // print(guruMapel);
                                // print(topik);

                                var indikatordataAwal = index;
                                var indikatorDataAkhir =
                                    data['jadwal-siswa'].length;

                                var hariAktifNow = hariAktif;

                                return JadwalKegiatan(
                                    indikatordataAwal,
                                    indikatorDataAkhir,
                                    widthApp,
                                    jamDiMulai,
                                    jamBerakhir,
                                    mapel,
                                    jadwalID,
                                    hariAktifNow,
                                    tanggalKegiatan,
                                    statusKehadiran,
                                    guruMapel,
                                    topik);
                              },
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: heightApp * 0.01),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Jam Pengganti",
                                style: TextStyle(fontSize: 14),
                              )),
                          lengthJadwalPengganti == 0
                              ? SizedBox(
                                  height: heightApp * 0.4,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: heightApp * 0.1,
                                    ),
                                    child: const Text(
                                      "Tidak Ada Jadwal Pengganti",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  // height: heightApp * 0.5,
                                  width: widthApp * 0.95,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 20),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: lengthJadwalPengganti,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      var jamDiMulai = data['jadwal-pengganti']
                                          [index]['waktu_mulai'];
                                      var jamBerakhir = data['jadwal-pengganti']
                                          [index]['waktu_berakhir'];
                                      var guruMapel = data['jadwal-pengganti']
                                              [index]['jadwal_pelajaran']
                                          ['guru']['nama'];

                                      var mapel = data['jadwal-pengganti']
                                              [index]['jadwal_pelajaran']
                                          ['mata_pelajaran']['nama'];
                                      var jadwalID = data['jadwal-pengganti']
                                          [index]['jadwal_pelajaran_id'];
                                      String formatjam =
                                          DateFormat(' . M . y', "id_ID")
                                              .format(now);
                                      var tanggalKegiatan =
                                          tanggals[index] + formatjam;

                                      var data3 = data['jadwal-pengganti']
                                              [index]['jadwal_pelajaran']
                                          ['monitoring_pembelajarans'];

                                      var statusKehadiran =
                                          'Presensi belum diinputkan';
                                      var topik =
                                          'Agenda pembelajaran belum diinputkan';

                                      if (data3.length != 0) {
                                        topik = data3[0]['topik'];
                                        if (data3[0]['kehadiran_pembelajarans']
                                                .length !=
                                            0) {
                                          // print('ada data');
                                          statusKehadiran = data3[0]
                                                  ['kehadiran_pembelajarans'][0]
                                              ['status'];
                                        }
                                      }

                                      var hariAktifNow = hariAktif;
                                      var indikatordataAwal = index;
                                      var indikatorDataAkhir =
                                          data['jadwal-pengganti'].length;
                                      // return Text('data');
                                      return JadwalKegiatan(
                                          indikatordataAwal,
                                          indikatorDataAkhir,
                                          widthApp,
                                          jamDiMulai,
                                          jamBerakhir,
                                          mapel,
                                          jadwalID,
                                          hariAktifNow,
                                          tanggalKegiatan,
                                          statusKehadiran,
                                          guruMapel,
                                          topik);
                                    },
                                    scrollDirection: Axis.vertical,
                                  ),
                                )
                        ],
                      );
                    }
                  } else {
                    return SizedBox(
                      height: heightApp * 1.1,
                      child: const Center(
                        child: Text(
                          "Periksa koneksi internet anda",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }
}
