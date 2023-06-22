import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/presensi_controller.dart';
import 'package:simobel/models/siswa.dart';

import 'package:simobel/screens/pages/guru_page/validasi_kelas.dart';

class PresensiTidakValid extends StatefulWidget {
  final dynamic kelas;
  final dynamic jadwalId;
  final dynamic kelasId;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;
  PresensiTidakValid(this.kelas, this.jadwalId, this.kelasId, this.jamDimulai,
      this.jamBerakhir,
      {super.key});

  @override
  State<PresensiTidakValid> createState() => _PresensiTidakValidState();
}

class _PresensiTidakValidState extends State<PresensiTidakValid> {
  final PresensiController presensiController = Get.put(PresensiController());

  final TextEditingController inputAgendaController = TextEditingController();

  final TextEditingController inputKeteranganGuruController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late dynamic returnSiswa;

  @override
  void initState() {
    inputAgendaController.text = '';
    inputKeteranganGuruController.text = '';
    super.initState();
  }

  final List<String> items = [
    'hadir',
    'izin',
    'sakit',
    'alfa',
    'dinas dalam',
    'dinas luar',
  ];
  Rx<Value?> nullableVariable = Rx<Value?>(null);
  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    // print('Ini tando get siswa');
    // print(jadwalId);
    // print(kelasId);
    void _submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
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
                    presensiController.inputPresensiTidakValid(
                      widget.jadwalId,
                      inputKeteranganGuruController.text,
                      inputAgendaController.text,
                      presensi,
                    );
                    print('Sukses');
                    Get.back();
                    Get.back();
                    Get.off(const ValidasiKelas());
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
        child: FloatingActionButton(
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
                // height: heightApp * 0.05,
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: heightApp * 0.005),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Keterangan Guru",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              width: widthApp * 0.9,
              // height: heightApp * 0.07,
              child: TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Masukan keterangan guru';
                  }
                  return null;
                },
                controller: inputKeteranganGuruController,
                decoration: const InputDecoration(
                  border:
                      UnderlineInputBorder(borderSide: BorderSide(width: 20)),
                  hintText: 'Keterangan guru tidak hadir',
                ),
              ),
            ),
            Container(
                // height: heightApp * 0.05,
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: heightApp * 0.01),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Agenda Pembelajaran",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              width: widthApp * 0.9,
              // height: heightApp * 0.07,
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
                  border:
                      UnderlineInputBorder(borderSide: BorderSide(width: 20)),
                  hintText: 'Laporan Materi Pembelajaran',
                ),
              ),
            ),
            Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Presensi Siswa",
                  style: TextStyle(fontSize: 20),
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
                  future: presensiController.getSiswa(widget.kelasId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          heightFactor: 5,
                          child: SizedBox(
                            height: heightApp * 0.07,
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
                      var data = jsonDecode(snapshot.data);
                      returnSiswa = data['siswa'].map((dynamic siswa) {
                        String id = siswa['id'].toString();
                        String nama = siswa['nama'];

                        return Siswa(
                            siswaId: id,
                            namaSiswa: nama,
                            ketHadir: 'Hadir'.obs);
                      }).toList();

                      if (data['siswa'].length == 0) {
                        return const Text(
                          "Tidak Ada Siswa",
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return SizedBox(
                          // height: heightApp * 0.65,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 3,
                                );
                              },
                              padding: EdgeInsets.only(
                                  bottom: heightApp * 0.08,
                                  top: heightApp * 0.02),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              width: widthApp * 0.5,
                                              child: Text(
                                                  returnSiswa[index].namaSiswa),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Obx(() => Container(
                                                    width: widthApp * 0.24,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            right: 5),
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              226, 233, 243),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      child: Center(
                                                        child: DropdownButton<
                                                            String>(
                                                          // isExpanded: true,
                                                          underline:
                                                              Container(),
                                                          value: inputAgendaController
                                                                      .text
                                                                      .trim()
                                                                      .isNotEmpty &&
                                                                  inputKeteranganGuruController
                                                                      .text
                                                                      .trim()
                                                                      .isNotEmpty
                                                              ? returnSiswa[
                                                                      index]
                                                                  .ketHadir
                                                                  .value
                                                              : nullableVariable
                                                                  .value,
                                                          items: items.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            // print(
                                                            //     'ini value $value');
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
                                                            //     'ini textUI $textUi');
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: textUi,
                                                              child:
                                                                  Text(textUi),
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
                        );
                      }
                    } else {
                      return Text('');
                      // Text(
                      //   "Tidak Ada Jaringan Internet",
                      //   textAlign: TextAlign.center,
                      // );
                    }
                  }),
            ),
            // SizedBox(
            //     width: widthApp * 0.8,
            //     child: ElevatedButton(
            //         onPressed: () {
            //           _submit();
            //         },
            //         child: Text('Simpan'))),
          ],
        ),
      ))),
    );
  }
}
