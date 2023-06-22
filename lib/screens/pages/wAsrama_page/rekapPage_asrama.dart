import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:simobel/screens/auth/widgets/myAlertRekap.dart';

class RekapWaliAsrama extends StatefulWidget {
  const RekapWaliAsrama({super.key});

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  State<RekapWaliAsrama> createState() => _RekapWaliAsramaState();
}

class _RekapWaliAsramaState extends State<RekapWaliAsrama> {
  final ReceivePort _port = ReceivePort();
  // RxString? selectedKelas;

  @override
  void initState() {
    super.initState();
    // fetchDataFromApi();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      // int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(RekapWaliAsrama.downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  final List<String> label = ['Daftar Pertemuan Wali Asrama'];

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Container(
                height: heightApp * 0.1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Rekapitulasi",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                height: heightApp * 0.7,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: heightApp * 0.14,
                            width: widthApp * 0.92,
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
                                padding: EdgeInsets.only(left: widthApp * 0.08),
                                child: Text(
                                  label[index],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(172, 3, 3, 11)),
                                ),
                              ),
                              const SizedBox(
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
                                        return MyAlert(label[index]);
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
                      return const Divider();
                    },
                    itemCount: label.length)),
          ],
        )),
      ),
    );
  }
}
