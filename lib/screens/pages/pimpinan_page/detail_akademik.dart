// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/pimpinan_controller.dart';

class DetailAkademik extends StatelessWidget {
  DetailAkademik(this.namaKelas, this.waktuMulai, this.waktuBerakhir,
      this.tanggal, this.hari, this.kelasId,
      {super.key});
  late final dynamic namaKelas;
  late final dynamic waktuMulai;
  late final dynamic waktuBerakhir;
  late final dynamic tanggal;
  late final dynamic hari;
  late final dynamic kelasId;

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi yang akan dilakukan saat tombol kembali ditekan
            // Misalnya, navigasi ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          namaKelas.toString(),
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: FutureBuilder(
          future: PimpinanController().getDetailAkademik(
              waktuMulai, waktuBerakhir, tanggal, hari, kelasId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  heightFactor: 15,
                  child: SizedBox(
                    // height: heightApp * 0.05,
                    child: const LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      strokeWidth: 1,
                      colors: [
                        Color.fromARGB(255, 33, 86, 243),
                        Colors.red,
                        Color.fromARGB(255, 216, 142, 23),
                      ],
                    ),
                  ));
            }
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data);
              var monitoring = data['jadwal'][0]['monitoring_pembelajarans'][0];
              var waktuMulai =
                  monitoring['waktu_mulai'].toString().substring(0, 5);
              var waktuBerakhir =
                  monitoring['waktu_berakhir'].toString().substring(0, 5);

              var statusValidasi =
                  toBeginningOfSentenceCase(monitoring['status_validasi']);
              var mapel = data['jadwal'][0]['mata_pelajaran']['nama'];
              var guruMapel = data['jadwal'][0]['guru']['nama'];
              var presensi = data['presensi'];

              // print(data);
              return Column(
                children: [
                  Container(
                      // height: heightApp * 0.05,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: heightApp * 0.01),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Tanggal dan Waktu",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    // height: heightApp * 0.06,
                    width: widthApp * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ]),
                    child: Text('${tanggal}'
                        ' | '
                        '${waktuMulai} WIB'
                        ' - '
                        '${waktuBerakhir} WIB'),
                  ),
                  Container(
                      // height: heightApp * 0.05,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: heightApp * 0.01),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Status",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    // height: heightApp * 0.06,
                    width: widthApp * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ]),
                    child: Text(statusValidasi!),
                  ),
                  Container(
                      // height: heightApp * 0.05,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: heightApp * 0.01),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Mata pelajaran",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    // height: heightApp * 0.06,
                    width: widthApp * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ]),
                    child: Text(mapel),
                  ),
                  Container(
                      // height: heightApp * 0.05,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: heightApp * 0.01),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Guru mata pelajaran",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    // height: heightApp * 0.06,
                    width: widthApp * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ]),
                    child: Text(guruMapel),
                  ),
                  Container(
                      // height: heightApp * 0.05,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: heightApp * 0.01),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Agenda pembelajaran",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    height: heightApp * 0.11,
                    width: widthApp * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ]),
                    child: Text(
                      '${monitoring['topik']}',
                      maxLines: 3,
                    ),
                  ),
                  Container(
                      // height: heightApp * 0.05,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: heightApp * 0.01),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Detail kehadiran",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    width: widthApp * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          // height: heightApp * 0.05,
                          width: widthApp * 0.58,
                          decoration: BoxDecoration(
                              color: Color(0xffE8F1FE),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
                          child: Text('Nama Siswa'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          // height: heightApp * 0.05,
                          width: widthApp * 0.3,
                          decoration: BoxDecoration(
                              color: Color(0xffE8F1FE),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
                          child: Text('Status'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: heightApp * 0.01,
                  ),
                  Container(
                    height: heightApp * 0.4,
                    width: widthApp * 0.9,
                    child: ListView.separated(
                        padding: EdgeInsets.only(bottom: heightApp * 0.02),
                        itemBuilder: (context, index) {
                          return Container(
                            // padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            // height: heightApp * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 10, bottom: 10),
                                    // color: Colors.amber,
                                    width: widthApp * 0.5,
                                    child: Text(presensi[index]['siswa'])),
                                Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    alignment: Alignment.center,
                                    // height: heightApp * 0.05,
                                    width: widthApp * 0.25,
                                    decoration: BoxDecoration(
                                      color: presensi[index]['presensi'] ==
                                              'alfa'
                                          ? Color(0xffF2C6C4)
                                          : presensi[index]['presensi'] ==
                                                  'dinas dalam'
                                              ? Color(0xffFAE4C4)
                                              : presensi[index]['presensi'] ==
                                                      'dinas luar'
                                                  ? Color(0xffFAE4C4)
                                                  : presensi[index]
                                                              ['presensi'] ==
                                                          'sakit'
                                                      ? Color(0xffF2C6C4)
                                                      : presensi[index][
                                                                  'presensi'] ==
                                                              'izin'
                                                          ? Color(0xffFAE4C4)
                                                          : Color(0xffE8F1FE),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: presensi[index]['presensi'] == 'alfa'
                                        ? Text(
                                            presensi[index]['presensi']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Color(0xff6C2927),
                                                fontSize: 14),
                                          )
                                        : presensi[index]['presensi'] ==
                                                'dinas dalam'
                                            ? Text(
                                                presensi[index]['presensi']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Color(0xff785627),
                                                    fontSize: 14),
                                              )
                                            : presensi[index]['presensi'] ==
                                                    'dinas luar'
                                                ? Text(
                                                    presensi[index]['presensi']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff785627),
                                                        fontSize: 14),
                                                  )
                                                : presensi[index]['presensi'] ==
                                                        'sakit'
                                                    ? Text(
                                                        presensi[index]
                                                                ['presensi']
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff6C2927),
                                                            fontSize: 14),
                                                      )
                                                    : presensi[index]
                                                                ['presensi'] ==
                                                            'izin'
                                                        ? Text(
                                                            presensi[index]
                                                                    ['presensi']
                                                                .toString()
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff6C2927),
                                                                fontSize: 14),
                                                          )
                                                        : Text(
                                                            presensi[index]
                                                                    ['presensi']
                                                                .toString()
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Container(
                              color: Colors.black12,
                              child: SizedBox(
                                height: 1,
                              ),
                            ),
                        itemCount: presensi.length),
                  ),
                  SizedBox(
                      // height: heightApp * 0.05,
                      ),
                ],
              );
            } else {
              return SizedBox(
                height: heightApp * 0.7,
                child: Center(
                  child: Text(
                    'Belum ada presensi',
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
              );
            }
          },
        )),
      ),
    );
  }
}
