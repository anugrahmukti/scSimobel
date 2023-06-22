import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simobel/screens/pages/guru_page/presensiGuruPage.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class JadwalMengajar extends StatefulWidget {
  final int monLength;
  final int iniIndex;
  final int indikatorJumlahData;
  final double widthApp;
  dynamic jamAktif;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;
  final dynamic kelas;
  final dynamic mapel;
  final dynamic kelasID;
  final dynamic jadwalID;
  final dynamic hariAktifNow;

  JadwalMengajar(
      this.monLength,
      this.iniIndex,
      this.indikatorJumlahData,
      this.widthApp,
      this.jamAktif,
      this.jamDimulai,
      this.jamBerakhir,
      this.kelas,
      this.mapel,
      this.jadwalID,
      this.kelasID,
      this.hariAktifNow,
      {super.key});

  @override
  State<JadwalMengajar> createState() => _JadwalMengajarState();
}

class _JadwalMengajarState extends State<JadwalMengajar> {
  String hariAktif = DateFormat('EEEE', "id_ID").format(DateTime.now());
  Color _backgroundColor = Color(0xffE3E6EB);
  late bool presensiAktif = false;

  String myVariable = 'Initial Data';
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Ubah variabel secara periodik
      setState(() {
        DateFormat format = DateFormat('HH:mm:s');
        DateTime jamAktif3 = format.parse(widget.jamAktif.value);
        DateTime jamDimulai3 = format.parse(widget.jamDimulai);
        DateTime jamBerakhir3 = format.parse(widget.jamBerakhir);
        if (hariAktif == widget.hariAktifNow.value &&
            jamAktif3.isBefore(jamBerakhir3) &&
            jamAktif3.isAfter(jamDimulai3) &&
            widget.monLength == 0) {
          setState(() {
            _backgroundColor = Color(0xffD7E5F9);
            presensiAktif = true;
          });
        } else {
          setState(() {
            presensiAktif = false;
            _backgroundColor = Color(0xffE3E6EB);
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer(); // updateUi();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    widget.jamAktif = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    return Obx(() => Center(
          child: TimelineTile(
            isLast: widget.iniIndex == widget.indikatorJumlahData - 1,
            beforeLineStyle: LineStyle(
                thickness: widthApp * 0.003, color: const Color(0xff051D2D)),
            indicatorStyle: IndicatorStyle(
                width: widthApp * 0.015, color: const Color(0xff051D2D)),
            alignment: TimelineAlign.manual,
            lineXY: 0.16,
            endChild: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10),
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _backgroundColor = const Color(0xffE8F1FE);
                  });
                },
                onTapUp: (_) {
                  DateFormat format = DateFormat('HH:mm:s');
                  DateTime jamAktif2 = format.parse(widget.jamAktif.value);
                  DateTime jamDimulai2 = format.parse(widget.jamDimulai);
                  DateTime jamBerakhir2 = format.parse(widget.jamBerakhir);
                  print(widget.jamAktif);
                  print(widget.jamDimulai);
                  print(widget.jamBerakhir);
                  print("===============");
                  print(jamAktif2);
                  print(jamDimulai2);
                  print(jamBerakhir2);

                  if (hariAktif == widget.hariAktifNow.value &&
                      jamAktif2.isBefore(jamBerakhir2) &&
                      jamAktif2.isAfter(jamDimulai2) &&
                      widget.monLength == 0) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PresensiBelajarGuru(
                          widget.kelas,
                          widget.jadwalID,
                          widget.kelasID,
                          widget.jamDimulai,
                          widget.jamBerakhir);
                    }));
                  } else {
                    var message;
                    if (widget.monLength == 1) {
                      message = 'Presensi sudah diinputkan';
                    } else {
                      message =
                          'Anda tidak bisa mengakses presensi diluar jam pelajaran';
                    }
                    Get.defaultDialog(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      radius: 4,
                      title: "Pemberitahuan",
                      middleText: message,
                      confirm: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("OK"),
                      ),
                    );
                  }
                  if (presensiAktif == true) {
                    setState(() {
                      _backgroundColor = Color(0xffD7E5F9);
                    });
                  } else {
                    _backgroundColor = Color(0xffE3E6EB);
                  }
                },
                onTapCancel: () {
                  if (presensiAktif == true) {
                    setState(() {
                      _backgroundColor = Color(0xffD7E5F9);
                    });
                  } else {
                    _backgroundColor = Color(0xffE3E6EB);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightApp * 0.01),
                  // height: widthApp,
                  // height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                      child: Material(
                    type: MaterialType.transparency,
                    child: ListTile(
                      dense: true,
                      title: Text(
                        widget.kelas,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        widget.mapel,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Column(
                        children: [
                          Visibility(
                              visible: false,
                              child: Text(
                                widget.jamAktif.toString(),
                                style: const TextStyle(fontSize: 12),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 13),
                            child: widget.monLength == 1
                                ? Text(
                                    "Sudah Presensi",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xff51A64F)),
                                  )
                                : Text("Presensi 》"),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
              ),
            ),
            startChild: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              // width: widthApp * 0.15,
              child: Center(
                  child: Text(
                widget.jamDimulai.toString().substring(0, 5),
                style: const TextStyle(color: Color(0xff051D2D)),
              )),
            ),
          ),
        ));
  }
}
