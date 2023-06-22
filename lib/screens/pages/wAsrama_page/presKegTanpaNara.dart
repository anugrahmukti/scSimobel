import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/presensi_controller.dart';
import 'package:simobel/controllers/waliAsrama_controller.dart';
import 'package:simobel/models/siswa.dart';

// ignore: must_be_immutable
class PresensiKegTanpaNara extends StatefulWidget {
  final dynamic namaKelas;
  final dynamic jadwalId;
  final dynamic kelasId;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;
  final dynamic kegiatanId;
  PresensiKegTanpaNara(this.namaKelas, this.jadwalId, this.kelasId,
      this.jamDimulai, this.jamBerakhir, this.kegiatanId,
      {super.key});

  @override
  State<PresensiKegTanpaNara> createState() => _PresensiKegTanpaNaraState();
}

class _PresensiKegTanpaNaraState extends State<PresensiKegTanpaNara> {
  final PresensiController presensiController = Get.put(PresensiController());

  final TextEditingController inputAgendaController = TextEditingController();

  late dynamic returnSiswa;

  final List<String> items = [
    'hadir',
    'izin',
    'sakit',
    'alfa',
    'dinas dalam',
    'dinas luar',
  ];
  late Future<String?> _getData;
  var json;
  Rx<String> statusPresensi = "Belum Presensi".obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData = WaliAsramaController()
        .getSiswaAsrama(widget.jadwalId, widget.kelasId, widget.kegiatanId)
        .then((value) {
      var formattedBody = jsonDecode(value!);
      String prettyBody = JsonEncoder.withIndent('  ').convert(formattedBody);
      debugPrint(prettyBody);
      print('anugrahmukti');
      json = jsonDecode(value);
      statusPresensi.value = json['status-presensi'];
      print(json['status-presensi']);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    print('Ini tando get siswa');

    void _submit() {
      List<Map<String, dynamic>> presensi = [];
      for (var i in returnSiswa) {
        var absen;
        if (i.ketHadir.value == 'DD') {
          absen = 'dinas dalam';
        } else if (i.ketHadir.value == 'DL') {
          absen = 'dinas luar';
        } else {
          absen = i.ketHadir.value.toString().toLowerCase();
        }
        print(absen);
        presensi.add({
          '"siswaID"': '"' + i.siswaId + '"',
          '"status"': '"' + absen + '"'
        });
      }
      Get.dialog(AlertDialog(
          title: const Text(
            "Konfirmasi Presensi ?",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16),
          ),
          // content: const Text("Konfirmasi Presensi ?", textAlign: TextAlign.left),
          actions: [
            TextButton(
              child: const Text(
                'Batalkan',
                style: TextStyle(color: Color(0xffB54542)),
              ),
              onPressed: () {
                // print(selectedMapel);
                Get.back();
              },
            ),
            ElevatedButton(
              onPressed: () {
                WaliAsramaController().inputPresKegTanpaNara(widget.jamDimulai,
                    widget.jamBerakhir, widget.jadwalId, presensi);
                print('Sukses');
                Get.back();
                Get.back();
                final snackBar = SnackBar(
                  content: const Text('Input presensi berhasil'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Lanjutkan'),
              style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
            )
          ]));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0.4,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          widget.namaKelas.toString(),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: widthApp * 0.9,
        child: Obx(() => FloatingActionButton(
            backgroundColor: statusPresensi.value == "Sudah Presensi"
                ? const Color(0xff51A64F)
                : const Color(0xff1363DF),
            mini: true, // Mengatur ukuran menjadi lebih kecil
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Mengatur radius sudut
            ),
            onPressed: () {
              _submit();
            },
            child: statusPresensi.value == "Sudah Presensi"
                ? const Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'SIMPAN',
                    style: TextStyle(color: Colors.white),
                  ))),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
        children: [
          SizedBox(
            // height: heightApp*0.,
            child: FutureBuilder(
                future: _getData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        heightFactor: 9,
                        child: SizedBox(
                          height: heightApp * 0.1,
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
                  // print("ini print snapshot");
                  // print('ini data get siswaa');
                  if (snapshot.hasData) {
                    print('-------------------');
                    print(statusPresensi);
                    var data = jsonDecode(snapshot.data);
                    returnSiswa = data['siswa'].map((dynamic siswa) {
                      String id = siswa['id'].toString();
                      String nama = siswa['nama'];
                      var absen;
                      if (data['presensi'][id] == 'dinas dalam') {
                        absen = 'DD';
                      } else if (data['presensi'][id] == 'dinas luar') {
                        absen = 'DL';
                      } else {
                        absen = toBeginningOfSentenceCase(data['presensi'][id]);
                      }
                      // print(absen);
                      var ketHadir = absen;
                      // print('ini keterangan $ketHadir');
                      return Siswa(
                          siswaId: id,
                          namaSiswa: nama,
                          ketHadir: '${ketHadir}'.obs);
                    }).toList();

                    // print('TANDO');
                    // print(returnSiswa[0].siswaId);

                    if (data['siswa'].length == 0) {
                      return SizedBox(
                        height: heightApp * 0.7,
                        child: const Center(
                          child: Text(
                            "Tidak Ada Siswa",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        child: Column(
                          children: [
                            Container(
                                // height: heightApp * 0.05,
                                padding: EdgeInsets.only(
                                  top: heightApp * 0.01,
                                  bottom: heightApp * 0.01,
                                  left: widthApp * 0.05,
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Presensi Siswa",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )),
                            SizedBox(
                              width: widthApp * 0.9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    // height: heightApp * 0.05,
                                    width: widthApp * 0.63,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE8F1FE),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: const Text('Nama'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    // height: heightApp * 0.05,
                                    width: widthApp * 0.25,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE8F1FE),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ]),
                                    child: const Text('Status'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              // height: heightApp * 0.75,
                              child: ListView.separated(
                                  padding: EdgeInsets.only(
                                      bottom: heightApp * 0.08,
                                      top: heightApp * 0.01),
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 3,
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: returnSiswa.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: widthApp * 0.9,
                                            // height: heightApp * 0.055,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 2,
                                                    offset: const Offset(0,
                                                        1), // changes position of shadow
                                                  ),
                                                ]),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  width: widthApp * 0.5,
                                                  child: Text(returnSiswa[index]
                                                      .namaSiswa),
                                                ),
                                                Container(
                                                  child: Obx(() => Container(
                                                        width: widthApp * 0.24,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                bottom: 5,
                                                                right: 5),
                                                        child: DecoratedBox(
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  226,
                                                                  233,
                                                                  243),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          child: Center(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              // isExpanded: true,
                                                              underline:
                                                                  Container(),
                                                              value:
                                                                  returnSiswa[
                                                                          index]
                                                                      .ketHadir
                                                                      .value,
                                                              items: items.map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                                var textUi;
                                                                if (value ==
                                                                    'dinas dalam') {
                                                                  textUi = 'DD';
                                                                } else if (value ==
                                                                    'dinas luar') {
                                                                  textUi = 'DL';
                                                                } else {
                                                                  textUi =
                                                                      toBeginningOfSentenceCase(
                                                                          value);
                                                                }

                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: textUi,
                                                                  child: Text(
                                                                      textUi),
                                                                );
                                                              }).toList(),
                                                              onChanged: (String?
                                                                  newValue) {
                                                                returnSiswa[index]
                                                                        .ketHadir
                                                                        .value =
                                                                    newValue;

                                                                // returnSiswa[index].update();
                                                                // print(returnSiswa[
                                                                //         index]
                                                                //     .ketHadir);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Column(
                      children: [
                        // CircularProgressIndicator(),
                        Text(
                          "Periksa internet anda",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ))),
    );
  }
}
