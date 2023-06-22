import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simobel/controllers/pimpinan_controller.dart';
import 'package:simobel/screens/pages/pimpinan_page/kelas_akademik.dart';

class ItemAkademikPimpinan extends StatelessWidget {
  const ItemAkademikPimpinan({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
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
    //
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xffF9FBFD),
        // height: heightApp * 1.8,
        child: Column(
          children: [
            Container(
                height: heightApp * 0.1 - 20,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Monitoring",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  var warnaTombol = const Color(0xffECEFF3);
                  var warnaTombolAktif = const Color(0xff1363DF);
                  var warnaTextHitam = Colors.black;
                  var warnaTextPutih = Colors.white;
                  return Obx(() => GestureDetector(
                        onTapDown: (_) {
                          print(hariAktif);
                          String formatTanggal = DateFormat('y/MM/', "id_ID")
                              .format(datesOfWeek[index]);

                          hariAktif.value = hari[index];
                          tanggalHariIni.value =
                              formatTanggal + tanggals[index];
                          tanggalIndex = tanggals[index];
                          print('didalam ontap $tanggalIndex');
                          print('tanggal hari ini $tanggalHariIni');
                          print('hari aktif ontap $hariAktif');
                        },
                        child: Container(
                          width: widthApp * 0.15,
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
              height: heightApp * 0.02,
            ),
            Obx(() => SizedBox(
                width: widthApp * 0.9,
                // height: heightApp * 0.54,
                child: FutureBuilder(
                    future: PimpinanController().getMonitoringAkademik(
                        hariAktif.toString(), tanggalHariIni),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: heightApp * 0.65,
                          child: Center(
                            // heightFactor: 1,
                            child: SizedBox(
                              height: heightApp * 0.05,
                              child: const LoadingIndicator(
                                indicatorType: Indicator.ballSpinFadeLoader,
                                strokeWidth: 1,
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
                        var waktu = data['waktu'];
                        // print(data
                        return ListView.separated(
                            padding: EdgeInsets.only(bottom: heightApp * 0.2),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: waktu.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: heightApp * 0.01,
                              );
                            },
                            itemBuilder: (context, index) {
                              var nilaiPersen = double.parse(
                                  waktu[index]['persentase'].toString());

                              var persen = nilaiPersen * 100;
                              print(waktu[index]['persentase']);
                              print('=================');
                              print('nilai persen $nilaiPersen');
                              print('persen $persen');
                              print(persen.toString());

                              print('stringpersen');
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xffFDFEFF),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                // height: heightApp * 0.11,
                                child: Center(
                                  child: ListTile(
                                    leading: SizedBox(
                                      // height: heightApp * 0.1,
                                      width: widthApp * 0.15,
                                      child: CircularPercentIndicator(
                                        // fillColor: Colors.black,
                                        radius: 25.0,
                                        lineWidth: 5.5,
                                        animation: true,
                                        percent: nilaiPersen,
                                        // nilaiPersen,
                                        center: Text(
                                          '${persen.round()}%',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Color(0xff2B8DEF)),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: const Color(0xff2B8DEF),
                                      ),
                                    ),
                                    // dense: true,
                                    // contentPadding: EdgeInsets.all(20),

                                    // isThreeLine: true,
                                    title: Text(
                                        'Jam Pelajaran ke ' '${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),

                                    subtitle: Text(
                                        '${waktu[index]['waktu_mulai']}-${waktu[index]['waktu_berakhir']}',
                                        style: const TextStyle(fontSize: 14)),

                                    trailing: const Text('Detail 》',
                                        style: TextStyle(fontSize: 12)),
                                    onTap: () {
                                      var waktuMulai =
                                          waktu[index]['waktu_mulai'];
                                      var waktuBerakhir =
                                          waktu[index]['waktu_berakhir'];

                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return KelasAkademik(
                                            waktuMulai,
                                            waktuBerakhir,
                                            tanggalHariIni,
                                            hariAktif.value);
                                      }));
                                    },
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: heightApp * 0.2, bottom: heightApp * 0.4),
                          child: const Center(
                            child: Text(
                              "Periksa Internet Anda",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        );
                      }
                    }))),
            // SizedBox(
            //   height: heightApp * 0.2,
            // )
          ],
        ),
      ),
    );
  }
}
