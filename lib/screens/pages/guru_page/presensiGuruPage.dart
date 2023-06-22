import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/presensi_controller.dart';
import 'package:simobel/models/siswa.dart';

import 'package:simobel/screens/pages/guru_page/dashboard_guru.dart';

// ignore: must_be_immutable
class PresensiBelajarGuru extends StatefulWidget {
  final dynamic kelas;
  final dynamic jadwalID;
  final dynamic kelasID;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;
  PresensiBelajarGuru(this.kelas, this.jadwalID, this.kelasID, this.jamDimulai,
      this.jamBerakhir,
      {super.key, this.returnSiswa});
  late dynamic returnSiswa;

  @override
  State<PresensiBelajarGuru> createState() => _PresensiBelajarGuruState();
}

class _PresensiBelajarGuruState extends State<PresensiBelajarGuru> {
  final PresensiController presensiController = Get.put(PresensiController());

  final TextEditingController inputAgendaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> items = [
    'hadir',
    'izin',
    'sakit',
    'alfa',
    'dinas dalam',
    'dinas luar',
  ];

  @override
  void initState() {
    inputAgendaController.text = '';
    super.initState();
  }

  Rx<Value?> nullableVariable = Rx<Value?>(null);
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    // print('Ini tando get siswa');
    // print(jadwalID);
    // print(kelasID);

    void _submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        List<Map<String, dynamic>> presensi = [];
        for (var i in widget.returnSiswa) {
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

        // print(presensi);

        Get.dialog(AlertDialog(
            title: const Text("Konfirmasi Presensi", textAlign: TextAlign.left),
            content: const Text(
                "Data presensi siswa tidak dapat diubah setelah dikonfirmasi. Anda yakin akan melanjutkan?",
                textAlign: TextAlign.left),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Batalkan')),
              ElevatedButton(
                  onPressed: () {
                    presensiController.inputPresensi(
                        widget.jamDimulai,
                        widget.jamBerakhir,
                        widget.jadwalID,
                        presensi,
                        inputAgendaController.text);
                    print('Sukses');
                    Get.back();
                    Get.back();
                    Get.off(const GuruDashboard());
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
                  child: const Text('Lanjutkan'))
            ]));
      }
    }

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
          widget.kelas,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: widthApp * 0.9,
        child:
            // ElevatedButton(
            //     style: ButtonStyle(
            //         backgroundColor: const MaterialStatePropertyAll(
            //             Color.fromARGB(255, 255, 255, 255)),
            //         shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(8.0),
            //             side: BorderSide(color: Color(0xff1363DF))))),
            //     onPressed: () {},
            //     child: Text(
            //       'SIMPAN',
            //       style: TextStyle(color: Color(0xff1363DF)),
            //     ))
            FloatingActionButton(
                backgroundColor: Color(0xff1363DF),
                mini: true, // Mengatur ukuran menjadi lebih kecil
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Mengatur radius sudut
                    side: BorderSide(color: Color(0xff1363DF))),
                onPressed: () {
                  _submit();
                },
                child: const Text(
                  'SIMPAN',
                  style: TextStyle(color: Colors.white),
                )),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: SingleChildScrollView(
          child: SafeArea(
              child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
                // color: Colors.amber,
                height: heightApp * 0.07,
                padding: EdgeInsets.only(left: widthApp * 0.05),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Agenda Pembelajaran",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              width: widthApp * 0.9,
              height: heightApp * 0.1,
              child: TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Masukan agenda pembelajaran';
                  }
                  return null;
                },
                controller: inputAgendaController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  errorStyle: TextStyle(fontSize: 12),
                  // border:
                  //     UnderlineInputBorder(borderSide: BorderSide(width: 5)),
                  hintText: 'Laporan Materi Pembelajaran',
                ),
              ),
            ),
            Container(
                height: heightApp * 0.05,
                padding: EdgeInsets.only(
                  left: widthApp * 0.05,
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Presensi Siswa",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              width: widthApp * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: const Text('Status'),
                  ),
                ],
              ),
            ),
            SizedBox(
              // height: heightApp*0.,
              child: FutureBuilder(
                  future: presensiController.getSiswa(widget.kelasID),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // print("ini print snapshot");
                    // print('ini data get siswaa');
                    if (snapshot.hasData) {
                      var data = jsonDecode(snapshot.data);
                      print(data);
                      widget.returnSiswa = data['siswa'].map((dynamic siswa) {
                        String id = siswa['id'].toString();
                        String nama = siswa['nama'];

                        return Siswa(
                            siswaId: id,
                            namaSiswa: nama,
                            ketHadir: 'Hadir'.obs);
                      }).toList();

                      // print('TANDO');
                      // print(returnSiswa[0].siswaId);

                      if (data['siswa'].length == 0) {
                        return const Text(
                          "Tidak Ada Siswa",
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return SizedBox(
                          // height: heightApp * 0.73,
                          child: ListView.separated(
                              padding: EdgeInsets.only(
                                  bottom: heightApp * 0.08,
                                  top: heightApp * 0.01),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 1,
                                );
                              },
                              itemCount: widget.returnSiswa.length,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              width: widthApp * 0.6,
                                              child: Text(
                                                  widget.returnSiswa[index]
                                                      .namaSiswa,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            Obx(() => Container(
                                                  width: widthApp * 0.24,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 226, 233, 243),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    child: Center(
                                                        child: DropdownButton<
                                                            dynamic>(
                                                      // isExpanded: true,
                                                      underline: Container(),
                                                      value:
                                                          inputAgendaController
                                                                  .text
                                                                  .trim()
                                                                  .isNotEmpty
                                                              ? widget
                                                                  .returnSiswa[
                                                                      index]
                                                                  .ketHadir
                                                                  .value
                                                              : nullableVariable
                                                                  .value,
                                                      items: items.map<
                                                              DropdownMenuItem<
                                                                  dynamic>>(
                                                          (dynamic value) {
                                                        // print(
                                                        //     'ini value ');
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
                                                        // print(
                                                        //     'ini textUI ');
                                                        return DropdownMenuItem<
                                                            dynamic>(
                                                          value: textUi,
                                                          child: Text(textUi),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (dynamic newValue) {
                                                        widget
                                                            .returnSiswa[index]
                                                            .ketHadir
                                                            .value = newValue;
                                                        // returnSiswa[index].update();
                                                        // print(returnSiswa[
                                                        //         index]
                                                        //     .ketHadir);
                                                      },
                                                    )),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      }
                    } else {
                      return Center(
                          heightFactor: 4,
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
                          ));

                      // Text(
                      //   "Tidak Ada Jaringan Internet",
                      //   textAlign: TextAlign.center,
                      // );
                    }
                  }),
            ),
            // SizedBox(
            //   height: heightApp * 0.06,
            //   width: widthApp * 0.9,
            //   child: ElevatedButton(onPressed: () {}, child: Text('SIMPAN')),
            // ),
            // SizedBox(
            //   height: 20,
            // )
          ],
        ),
      ))),
    );
  }

  // print(presensi);
}
