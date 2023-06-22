import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:simobel/screens/auth/widgets/myAlertRekap.dart';

class RekapPimpinan extends StatefulWidget {
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  State<RekapPimpinan> createState() => _RekapPimpinanState();
}

class _RekapPimpinanState extends State<RekapPimpinan> {
  final ReceivePort _port = ReceivePort();
  // RxString? selectedKelas;

  @override
  void initState() {
    super.initState();
    // fetchDataFromApi();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });
    FlutterDownloader.registerCallback(RekapPimpinan.downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  final List<String> pembelajaran = [
    'Daftar Pertemuan Akademik',
    'Keterlaksanaan Akademik',
    'Kehadiran Siswa Akademik'
  ];

  final List<String> kegiatan = [
    'Daftar Pertemuan Non-Akademik',
    'Kehadiran Siswa Non-Akademik'
  ];

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(heightApp * 0.075),
          child: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            // centerTitle: true,
            title: const Text(
              'Rekapitulasi',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          )),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          height: heightApp * 1.1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  // height: widthApp * 0.1,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: heightApp * 0.02),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Pembelajaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: heightApp * 0.5,
                width: widthApp * 0.92,
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: heightApp * 0.14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: widthApp * 0.06),
                                child: Text(
                                  pembelajaran[index],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(172, 3, 3, 11)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: heightApp * 0.045,
                                width: widthApp * 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return MyAlert(pembelajaran[index]);
                                      },
                                    );
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Color(0xFF1363DF)),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  child: const Text(
                                    "DOWNLOAD",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: heightApp * 0.02,
                      );
                    },
                    itemCount: pembelajaran.length),
              ),
              Container(
                  // height: widthApp * 0.05,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: heightApp * 0.01),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: heightApp * 0.4,
                width: widthApp * 0.9,
                child: ListView.separated(
                    padding: EdgeInsets.only(top: heightApp * 0.02),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: heightApp * 0.14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: widthApp * 0.06),
                                child: Text(
                                  kegiatan[index],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(172, 3, 3, 11)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: heightApp * 0.045,
                                width: widthApp * 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return MyAlert(kegiatan[index]);
                                      },
                                    );
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Color(0xFF1363DF)),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  child: const Text(
                                    "DOWNLOAD",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: heightApp * 0.02,
                      );
                    },
                    itemCount: kegiatan.length),
              )
            ],
          ),
        )),
      ),
    );
  }
}
