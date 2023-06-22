import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/presensi_controller.dart';
import 'package:simobel/controllers/waliAsrama_controller.dart';
import 'package:simobel/models/siswa.dart';

class PresensiKegNara extends StatefulWidget {
  final dynamic namaKelas;
  final dynamic jadwalId;
  final dynamic kelasId;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;
  final dynamic kegiatanId;
  PresensiKegNara(this.namaKelas, this.jadwalId, this.kelasId, this.jamDimulai,
      this.jamBerakhir, this.kegiatanId,
      {super.key});

  @override
  State<PresensiKegNara> createState() => _PresensiKegNaraState();
}

class _PresensiKegNaraState extends State<PresensiKegNara> {
  late Future<String?> _getData;
  late Future<String?> _getNarasumber;
  final PresensiController presensiController = Get.put(PresensiController());

  late final TextEditingController inputAgendaController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late dynamic returnSiswa;

  // bool showFloatingButton = false;

  final List<String> items = [
    'hadir',
    'izin',
    'sakit',
    'alfa',
    'dinas dalam',
    'dinas luar',
  ];
  final Rx<String> selectedValue = ''.obs;
  Rx<Value?> nullableVariable = Rx<Value?>(null);
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
      inputAgendaController.text = json['topik'];
      selectedValue.value = json['narasumber_id'];

      print(inputAgendaController.text);
      return value;
    });
    _getNarasumber = WaliAsramaController().getNarasumber();
    print(_getNarasumber);
    print(_getData);
  }

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    final Rx<String> validatorValue = ' '.obs;
    final Rx<String> message = ''.obs;

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
        print(presensi);
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
                  WaliAsramaController().inputPresKegNara(
                      widget.jamDimulai,
                      widget.jamBerakhir,
                      widget.jadwalId,
                      presensi,
                      selectedValue.value,
                      inputAgendaController.text);
                  print('Sukses');
                  Get.back();
                  Get.back();
                  final snackBar = SnackBar(
                    content: const Text('presensi sukses'),
                    action: SnackBarAction(
                      label: 'OK',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // Get.off( ApelKelas());
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
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
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
                ? Color(0xff51A64F)
                : Color(0xff1363DF),
            mini: true, // Mengatur ukuran menjadi lebih kecil
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Mengatur radius sudut
            ),
            onPressed: () {
              _submit();
            },
            child: statusPresensi.value == "Sudah Presensi"
                ? Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    'SIMPAN',
                    style: TextStyle(color: Colors.white),
                  ))),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: SingleChildScrollView(
          child: SafeArea(
              child: Form(
        key: _formKey,
        child: SizedBox(
          child: FutureBuilder(
              future: _getData,
              // WaliAsramaController().getSiswaAsrama(
              //     widget.jadwalId, widget.kelasId, widget.kegiatanId),
              builder: (context, AsyncSnapshot snapshot) {
                // print('jalan');
                // print("ini print snapshot");
                // print('ini data get siswaa');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      heightFactor: 12,
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
                if (snapshot.hasData) {
                  // showFloatingButton = true;
                  var data = jsonDecode(snapshot.data);
                  // print(data);
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
                    // toBeginningOfSentenceCase(data['presensi'][id]);
                    // inputAgendaController.text = data['topik'];
                    // selectedValue.value = data['narasumber_id'];
                    // var narasumberId = data['narasumber_id'];
                    // var topik = data['topik'];

                    // print('ini keterangan $ketHadir');
                    return Siswa(
                        siswaId: id,
                        namaSiswa: nama,
                        ketHadir: '${ketHadir}'.obs);
                  }).toList();

                  // print('TANDO');
                  // print(returnSiswa[0].siswaId);

                  if (data['siswa'].length == 0) {
                    // showFloatingButton = false;
                    return Column(
                      children: [
                        SizedBox(
                          height: heightApp * 0.7,
                          child: const Center(
                            child: Text(
                              "Tidak Ada Siswa",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // showFloatingButton = true;
                    return Column(
                      // mainAxisSize: MainAxisSize.max,
                      // textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                            // height: heightApp * 0.05,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Agenda Kegiatan",
                              style: TextStyle(fontSize: 18),
                            )),
                        SizedBox(
                          width: widthApp * 0.9,
                          // height: heightApp * 0.06,
                          child: TextFormField(
                            // autofocus: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                validatorValue.value = 'Masukan topik kegiatan';
                                return '';
                              }
                              return null;
                            },
                            onChanged: (vale) {
                              setState(() {
                                print(
                                    'ini selected value ${selectedValue.value}');
                                validatorValue.value = '';
                              });
                            },
                            controller: inputAgendaController,
                            decoration: const InputDecoration(
                              hintText: 'Topik kegiatan',
                            ),
                          ),
                        ),
                        Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              validatorValue.value,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          );
                        }),
                        Container(
                            // height: heightApp * 0.05,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Pemateri Kegiatan",
                              style: TextStyle(fontSize: 18),
                            )),
                        SizedBox(
                          width: widthApp * 0.9,
                          child: FutureBuilder(
                            future: _getNarasumber,
                            // WaliAsramaController().getNarasumber(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var jsonData = jsonDecode(snapshot.data);
                                var narasumber = jsonData['narasumber'];
                                return DropdownButtonFormField<dynamic>(
                                  hint: const Text('Pilih Narasumber Kegiatan'),
                                  value: selectedValue.value.isNotEmpty
                                      ? selectedValue.value
                                      : null,
                                  validator: (value) {
                                    print(value);
                                    if (value == null) {
                                      message.value = 'Pilih narasumber';
                                      return '';
                                    }
                                    return null;
                                  },
                                  items: narasumber
                                      .map<DropdownMenuItem<dynamic>>(
                                          (dynamic value) {
                                    return DropdownMenuItem<dynamic>(
                                      alignment: Alignment.centerLeft,
                                      value: value['id'].toString(),
                                      child: Text(value['nama']),
                                    );
                                  }).toList(),
                                  onChanged: (dynamic value) {
                                    selectedValue.value = value;
                                    message.value = '';
                                    print(selectedValue.value);
                                  },
                                );
                              } else {
                                return SizedBox(
                                  height: heightApp * 0.5,
                                  child: Center(
                                      heightFactor: 5,
                                      child: SizedBox(
                                        height: heightApp * 0.02,
                                        child: const LoadingIndicator(
                                          indicatorType:
                                              Indicator.ballSpinFadeLoader,
                                          strokeWidth: 1,
                                          colors: [
                                            Color.fromARGB(255, 33, 86, 243),
                                            Colors.red,
                                            Color.fromARGB(255, 216, 142, 23),
                                          ],
                                        ),
                                      )),
                                );
                              }
                            },
                          ),
                        ),
                        Obx(() {
                          if (selectedValue.value == '') {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                message.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          } else {
                            return const Text('');
                          }
                        }),
                        Container(
                            // height: heightApp * 0.05,
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
                          // height: heightApp * 0.5,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 3,
                                );
                              },
                              padding: EdgeInsets.only(
                                  bottom: heightApp * 0.08,
                                  top: heightApp * 0.01),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: returnSiswa.length,
                              itemBuilder: (context, index) {
                                // print('selected value= $selectedValue');
                                // print('validator value= $validatorValue');
                                // print('message value= $message');

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
                                            Obx(
                                              () => Container(
                                                width: widthApp * 0.24,
                                                padding: const EdgeInsets.only(
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
                                                        value: selectedValue
                                                                        .value !=
                                                                    '' &&
                                                                inputAgendaController
                                                                        .text !=
                                                                    ''
                                                            ? returnSiswa[index]
                                                                .ketHadir
                                                                .value
                                                            : nullableVariable
                                                                .value,

                                                        items: items.map<
                                                                DropdownMenuItem<
                                                                    dynamic>>(
                                                            (dynamic value) {
                                                          // print(
                                                          //     'value dropdown');
                                                          // print(value);
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
                                                              dynamic>(
                                                            value: textUi,
                                                            child: Text(textUi),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (dynamic newValue) {
                                                          returnSiswa[index]
                                                              .ketHadir
                                                              .value = newValue;

                                                          // returnSiswa[index].update();
                                                        },
                                                      ),
                                                    )),
                                              ),
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
                    );
                  }
                } else {
                  return SizedBox(
                    height: heightApp * 0.5,
                    child: Center(
                        heightFactor: 12,
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
                        )),
                  );
                }
              }),
        ),
      ))),
    );
  }
}
