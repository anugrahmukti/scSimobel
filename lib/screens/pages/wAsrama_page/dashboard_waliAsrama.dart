import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/controllers/logout_controller.dart';
import 'package:simobel/controllers/waliAsrama_controller.dart';
import 'package:simobel/screens/pages/wAsrama_page/kegNara.dart';
import 'package:simobel/screens/pages/wAsrama_page/kegTanpaNara.dart';

import '../../auth/widgets/ubahPassword.dart';

// ignore: must_be_immutable
class WaliAsramaDashboard extends StatelessWidget {
  late Object role = '';
  late Object namaWali = '';
  late Object angkatan = '';
  late dynamic username;

  final LogoutController logoutController = Get.put(LogoutController());

  WaliAsramaDashboard({super.key});

  getWaliAsrama() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    namaWali = prefs.get('namaWali')!;
    role = prefs.get('role')!;
    angkatan = prefs.get('angkatan')!;
    username = prefs.get('username');
    // print(namaWali);
    // print(role);
    // print(angkatan);
    return 'tes';
  }

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder(
          future: getWaliAsrama(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: SafeArea(
                    child: Column(
                  children: [
                    Container(
                      height: heightApp * 0.15,
                      alignment: Alignment.center,
                      child: ListTile(
                          // contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          leading: CircleAvatar(
                            radius: heightApp * 0.05,
                            child: Image.asset("assets/images/guru.png"),
                          ),
                          title: Text(
                            namaWali.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            'Wali Asrama Angkatan $angkatan',
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: PopupMenuButton<String>(
                            color: Colors.white,
                            icon: Icon(Icons.menu, color: Colors.black),
                            onSelected: (String value) {
                              if (value == "logout") {
                                Get.defaultDialog(
                                    radius: 4,
                                    title: 'Logout',
                                    middleText: 'Anda yakin ingin Logout ?',
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'Batalkan',
                                          style: TextStyle(
                                              color: Color(0xffB54542)),
                                        ),
                                        onPressed: () {
                                          // print(selectedMapel);
                                          Get.back();
                                        },
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          LogoutController().logout();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    Color(0xFF1363DF)),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ))),
                                        child: const Text('Lanjutkan'),
                                      )
                                    ]);
                              }
                              if (value == "ubahPassword") {
                                getUsername() async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  username = prefs.get('username');
                                  print('jalannnn');
                                  return 'tes';
                                }

                                getUsername();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UbahPassword(username);
                                  },
                                );
                              }

                              print('Opsi dipilih: $value');
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'ubahPassword',
                                child: Text('Ubah Password'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'logout',
                                child: Text('Logout'),
                              ),
                            ],
                          )
                          // IconButton(
                          //     onPressed: () async => Get.defaultDialog(
                          //             radius: 4,
                          //             title: 'Logout',
                          //             middleText: 'Anda yakin ingin Logout ?',
                          //             actions: [
                          //               TextButton(
                          //                 child: const Text(
                          //                   'Batalkan',
                          //                   style: TextStyle(
                          //                       color: Color(0xffB54542)),
                          //                 ),
                          //                 onPressed: () {
                          //                   // print(selectedMapel);
                          //                   Get.back();
                          //                 },
                          //               ),
                          //               ElevatedButton(
                          //                 onPressed: () {
                          //                   LogoutController().logout();
                          //                 },
                          //                 child: const Text('Lanjutkan'),
                          //                 style: ButtonStyle(
                          //                     backgroundColor:
                          //                         const MaterialStatePropertyAll(
                          //                             Color(0xFF1363DF)),
                          //                     shape: MaterialStatePropertyAll(
                          //                         RoundedRectangleBorder(
                          //                       borderRadius:
                          //                           BorderRadius.circular(4.0),
                          //                     ))),
                          //               )
                          //             ]),
                          //     icon: const Icon(Icons.logout_sharp)),
                          ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widthApp * 0.03,
                            vertical: heightApp * 0.02),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Kegiatan Siswa",
                          style: TextStyle(fontSize: 20),
                        )),
                    FutureBuilder(
                      future: WaliAsramaController().getJadwal(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              heightFactor: 4,
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
                        if (snapshot.hasData) {
                          var datajson = jsonDecode(snapshot.data);
                          var data = datajson['jadwal-angkatan'];

                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: heightApp * 0.01,
                              );
                            },
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widthApp * 0.04,
                                  vertical: heightApp * 0.005),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.15),
                                        spreadRadius: 0.5,
                                        blurRadius: 0.5,
                                        offset: const Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ]),
                                width: widthApp * 0.8,
                                // height: heightApp * 0.07,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: ListTile(
                                    // dense: true,
                                    title: Text(
                                      data[index]['kegiatan']['nama'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: Text(data[index]['hari']),
                                    onTap: () {
                                      var jadwalId = data[index]['id'];
                                      var jamMulai = data[index]['waktu_mulai'];
                                      var jamSelesai =
                                          data[index]['waktu_berakhir'];
                                      var kegiatanId =
                                          data[index]['kegiatan']['id'];
                                      var narasumber =
                                          data[index]['kegiatan']['narasumber'];
                                      // print(jadwalId);

                                      DateFormat format = DateFormat('HH:mm:s');
                                      DateTime jamAktif = DateTime.now();
                                      DateTime jamMulai2 =
                                          format.parse(jamMulai);
                                      DateTime jamSelesai2 =
                                          format.parse(jamSelesai);
                                      DateTime waktuAktif = DateTime(
                                          jamAktif.year,
                                          jamAktif.month,
                                          jamAktif.day,
                                          jamAktif.hour,
                                          jamAktif.minute);
                                      DateTime waktuMulai = DateTime(
                                          jamAktif.year,
                                          jamAktif.month,
                                          jamAktif.day,
                                          jamMulai2.hour,
                                          jamMulai2.minute);
                                      DateTime waktuSelesai = DateTime(
                                          jamAktif.year,
                                          jamAktif.month,
                                          jamAktif.day,
                                          jamSelesai2.hour,
                                          jamSelesai2.minute);

                                      print(jamAktif);
                                      print(jamMulai2);
                                      print(jamSelesai2);
                                      print('waktu aktif $waktuAktif');
                                      print('waktu mulai $waktuMulai');
                                      print('waktu selesai $waktuSelesai');
                                      if (narasumber == "0") {
                                        if (waktuAktif.isBefore(waktuSelesai) &&
                                            waktuAktif.isAfter(waktuMulai)) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            // return Text('data');
                                            return KegTanpaNarasumber(
                                                jadwalId,
                                                jamMulai,
                                                jamSelesai,
                                                kegiatanId);
                                          }));
                                        } else {
                                          Get.defaultDialog(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                            radius: 4,
                                            title: "Pemberitahuan",
                                            titleStyle: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            middleText:
                                                "Anda tidak bisa mengakses presensi diluar jam kegiatan",
                                            confirm: TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text("OK"),
                                            ),
                                          );
                                        }
                                      } else {
                                        var hari = data[index]['hari'];
                                        var hariSekarang =
                                            DateFormat('EEEE', 'id_ID')
                                                .format(DateTime.now());
                                        if (hariSekarang == hari &&
                                            waktuAktif.isBefore(waktuSelesai) &&
                                            waktuAktif.isAfter(waktuMulai)) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            // return Text('data');
                                            return KegNarasumber(
                                                jadwalId,
                                                jamMulai,
                                                jamSelesai,
                                                kegiatanId);
                                          }));
                                        } else {
                                          Get.defaultDialog(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                            radius: 4,
                                            title: "Pemberitahuan",
                                            middleText:
                                                "Anda tidak bisa mengakses presensi diluar jam kegiatan",
                                            confirm: TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text("OK"),
                                            ),
                                          );
                                        }
                                      }
                                      // print(jamMulai);
                                      // print(jamSelesai);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: heightApp * 0.5,
                            child: const Center(
                              child: Text(
                                'Periksa internet anda',
                                style: TextStyle(color: Colors.black38),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                )),
              );
            } else {
              return const Column(
                children: [
                  // CircularProgressIndicator(),
                  Center(
                    child: Text(''),
                  ),
                ],
              );
            }
          }),
    );
  }
}
