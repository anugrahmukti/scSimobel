// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/validasi_controller.dart';
import 'package:simobel/screens/pages/guru_page/presensi_tidak_valid.dart';
import 'package:timer_builder/timer_builder.dart';

// var data;

class ValidasiKelas extends StatefulWidget {
  const ValidasiKelas({super.key});

  @override
  State<ValidasiKelas> createState() => _ValidasiKelasState();
}

class _ValidasiKelasState extends State<ValidasiKelas> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (_) {
      // print(ubah + 1);
      // print('ini periodik');
      setState(() {});
    });
    // print('initstate');
  }

  var validasi = 'valid';
  void change(String index) {
    setState(() {
      validasi = index;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  int ubah = 0;
  @override
  Widget build(BuildContext context) {
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
        elevation: 0.4,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          "Validasi",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                TimerBuilder.periodic(Duration(seconds: 3), builder: (context) {
                  return FutureBuilder(
                      future: validasiController().getValidasi(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          var data = jsonDecode(snapshot.data);
                          // print(data);
                          return Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 15, top: 15),
                                  // height: heightApp * 0.05,
                                  // width: widthApp * 0.95,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8F1FE),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Validasi Jadwal Pengganti",
                                    style: TextStyle(fontSize: 18),
                                  )),
                              data['validasi-pengganti'].length == 0
                                  ? Text(
                                      "Tidak Ada Jadwal Pengganti",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black45),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          data['validasi-pengganti'].length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 5,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        var validasiPengganti =
                                            data['validasi-pengganti'][index]
                                                ['jadwal_pelajaran'];
                                        var kelas =
                                            validasiPengganti['kelas']['nama'];
                                        // // print(kelas);
                                        var mapel =
                                            validasiPengganti['mata_pelajaran']
                                                ['nama'];
                                        // // print(mapel);
                                        var guruMapel =
                                            validasiPengganti['guru']['nama'];
                                        // print(guruMapel);
                                        var jadwalID = validasiPengganti['id'];
                                        // // print(jadwalID);
                                        var kelasID =
                                            validasiPengganti['kelas']['id'];

                                        var jamDimulai =
                                            data['validasi-pengganti'][index]
                                                ['waktu_mulai'];
                                        var jamBerakhir2 =
                                            data['validasi-pengganti'][index]
                                                ['waktu_berakhir'];
                                        // print(jamBerakhir2);
                                        // return Text('data');
                                        return ValidationItem(
                                            validasiPengganti,
                                            kelas,
                                            mapel,
                                            guruMapel,
                                            index,
                                            jadwalID,
                                            kelasID,
                                            jamDimulai,
                                            jamBerakhir2);
                                      }),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  // height: heightApp * 0.05,
                                  // width: widthApp * 0.9,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8F1FE),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Validasi Kelas",
                                    style: TextStyle(fontSize: 18),
                                  )),
                              data['validasi-jadwal'].length == 0
                                  ? Text(
                                      "Tidak Ada Jadwal",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black45),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.only(
                                          bottom: heightApp * 0.02),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data['validasi-jadwal'].length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: heightApp * 0.015,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        var validasiJadwal =
                                            data['validasi-jadwal'][index];
                                        var kelas =
                                            validasiJadwal['kelas']['nama'];
                                        var mapel =
                                            validasiJadwal['mata_pelajaran']
                                                ['nama'];
                                        var guruMapel =
                                            validasiJadwal['guru']['nama'];
                                        var jadwalID = validasiJadwal['id'];
                                        var kelasID =
                                            validasiJadwal['kelas']['id'];
                                        var jamDimulai =
                                            validasiJadwal['waktu_mulai'];
                                        var jamBerakhir =
                                            validasiJadwal['waktu_berakhir'];
                                        // return Text('dataaaa');
                                        return ValidationItem(
                                            validasiJadwal,
                                            kelas,
                                            mapel,
                                            guruMapel,
                                            index,
                                            jadwalID,
                                            kelasID,
                                            jamDimulai,
                                            jamBerakhir);
                                      },
                                    ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: heightApp * 0.05),
                                  child: SizedBox(
                                    height: heightApp * 0.05,
                                    child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballSpinFadeLoader,
                                      strokeWidth: 1,
                                      colors: const [
                                        Color.fromARGB(255, 33, 86, 243),
                                        Colors.red,
                                        Color.fromARGB(255, 216, 142, 23),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: heightApp * 0.05,
                                ),
                                Text(
                                  "Periksa koneksi internet anda",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ValidationItem extends StatefulWidget {
  final validasi;
  final dynamic kelas;
  final dynamic mapel;
  final dynamic guruMapel;
  final dynamic jadwalID;
  final dynamic kelasID;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;

  final int index;

  const ValidationItem(
      this.validasi,
      this.kelas,
      this.mapel,
      this.guruMapel,
      this.index,
      this.jadwalID,
      this.kelasID,
      this.jamDimulai,
      this.jamBerakhir,
      {super.key});

  @override
  State<ValidationItem> createState() => _ValidationItemState();
}

class _ValidationItemState extends State<ValidationItem> {
  @override
  Widget build(BuildContext context) {
    final widthContainer = MediaQuery.of(context).size.width;
    final heightContainer = MediaQuery.of(context).size.height;
    // print('====================================');
    // print(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.only(
            left: widthContainer * 0.02,
            right: widthContainer * 0.02,
            top: heightContainer * 0.01,
            bottom: heightContainer * 0.01),
        // height: heightContainer * 0.15,
        // width: widthContainer * 0.95,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 0.5,
                blurRadius: 0.5,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // color: Colors.blue,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.kelas}", style: TextStyle(fontSize: 16)),
                    Text("${widget.mapel}", style: TextStyle(fontSize: 14)),
                    Text("${widget.guruMapel}", style: TextStyle(fontSize: 14)),
                  ]),
            ),
            Container(
              // color: Colors.green,
              child: Row(
                children: [
                  widget.validasi['monitoring_pembelajarans'].length != 0
                      ? widget.validasi['monitoring_pembelajarans'][0]
                                  ['status_validasi'] ==
                              'terlaksana'
                          ? Container(
                              padding:
                                  EdgeInsets.only(right: widthContainer * 0.05),
                              child: Text(
                                'Terlaksana',
                                style: TextStyle(color: Color(0xff51A64F)),
                              ),
                            )
                          : widget.validasi['monitoring_pembelajarans'][0]
                                      ['status_validasi'] ==
                                  'tidak terlaksana'
                              ? Container(
                                  padding: EdgeInsets.only(
                                      right: widthContainer * 0.05),
                                  // color: Colors.amber,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Tidak\nTerlaksana',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFBD4444),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceEvenly,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      iconSize: heightContainer * 0.07,
                                      color: Color(0xff51A64F),
                                      onPressed: () {
                                        Get.dialog(AlertDialog(
                                            title: Text("Konfirmasi Validasi",
                                                textAlign: TextAlign.left),
                                            content: Text(
                                                "Pembelajaran akan Tervalidasi?",
                                                textAlign: TextAlign.left),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text('Batalkan')),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    validasiController().valid(
                                                        widget.validasi[
                                                                'monitoring_pembelajarans']
                                                            [0]['id']);
                                                    final _ValidasiKelasState?
                                                        state =
                                                        context.findAncestorStateOfType<
                                                            _ValidasiKelasState>();
                                                    state?.change(widget.index
                                                        .toString());
                                                    Get.back();
                                                  },
                                                  child: Text('Lanjutkan'))
                                            ]));
                                        // print(validasi.value);
                                      },
                                      icon: Icon(Icons.check_circle),
                                    ),
                                    IconButton(
                                      color: Color(0xFFBD4444),
                                      iconSize: heightContainer * 0.07,
                                      onPressed: () {
                                        Get.dialog(AlertDialog(
                                            title: Text("Kelas Kosong?",
                                                textAlign: TextAlign.left),
                                            content: Text(
                                                "Pembelajaran tidak terlaksana dan anda akan mengisi presensi?",
                                                textAlign: TextAlign.left),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'Batalkan',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffE58A4E)),
                                                  )),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.off(PresensiTidakValid(
                                                      widget.kelas,
                                                      widget.jadwalID,
                                                      widget.kelasID,
                                                      widget.jamDimulai,
                                                      widget.jamBerakhir));
                                                },
                                                child: Text('YA'),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        const MaterialStatePropertyAll(
                                                            Color(0xFF1363DF)),
                                                    shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ))),
                                              )
                                            ]));
                                      },
                                      icon: Icon(Icons.cancel_rounded),
                                      // label: Text(""),
                                    )
                                  ],
                                )
                      : Row(
                          children: [
                            IconButton(
                              iconSize: heightContainer * 0.07,
                              color: Color(0xff51A64F),
                              onPressed: null,
                              icon: Icon(Icons.check_circle),
                            ),
                            IconButton(
                              color: Color(0xFFBD4444),
                              iconSize: heightContainer * 0.07,
                              onPressed: () {
                                Get.dialog(AlertDialog(
                                    title: Text("Kelas Kosong?",
                                        textAlign: TextAlign.left),
                                    content: Text(
                                        "Pembelajaran tidak terlaksana dan anda akan mengisi presensi?",
                                        textAlign: TextAlign.left),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'Batalkan',
                                            style: TextStyle(
                                                color: Color(0xffE58A4E)),
                                          )),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.off(PresensiTidakValid(
                                              widget.kelas,
                                              widget.jadwalID,
                                              widget.kelasID,
                                              widget.jamDimulai,
                                              widget.jamBerakhir));
                                        },
                                        child: Text('YA'),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    Color(0xFF1363DF)),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ))),
                                      )
                                    ]));
                              },
                              icon: Icon(Icons.cancel_rounded),
                              // label: Text(""),
                            )
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
