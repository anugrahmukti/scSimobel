import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/controllers/guru_controller.dart';
import 'package:simobel/screens/pages/guru_page/validasi_kelas.dart';
import 'package:simobel/services/notification_services.dart';
import '../../../controllers/logout_controller.dart';
import '../../auth/widgets/jadwal_mengajar.dart';
import '../../auth/widgets/ubahPassword.dart';
// import 'package:workmanager/workmanager.dart';

class GuruDashboard extends StatefulWidget {
  const GuruDashboard({super.key});

  @override
  State<GuruDashboard> createState() => _GuruDashboardState();
}

class _GuruDashboardState extends State<GuruDashboard> {
  late Object role;
  late Object namaGuru;
  late Object hariPiket;
  late int lengthJadwalPengganti;
  late Object waktuPiket;
  late Timer timer;
  late dynamic username;
  RxString jamAktif = DateFormat('HH:mm:s', "id_ID").format(DateTime.now()).obs;

  @override
  void initState() {
    super.initState();
    print(jamAktif.value);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      jamAktif.value = DateFormat('HH:mm:s', "id_ID").format(DateTime.now());
    });
    // print('initStatae');
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  LogoutController logoutController = Get.put(LogoutController());
  GuruController guruController = Get.put(GuruController());
  getGuru() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    namaGuru = prefs.get('namaGuru')!;
    role = prefs.get('role')!;
    hariPiket = prefs.get('hariPiket')!;
    waktuPiket = prefs.get('waktuPiket')!;
    username = prefs.get('username');

    return 'tes';
  }

  List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  @override
  Widget build(BuildContext context) {
    DateTime nows = DateTime.now();

    List<DateTime> tanggalNotif = [];
    for (int i = 0; i < 3; i++) {
      tanggalNotif.add(nows.add(Duration(days: i)));
    }

    List<String> jadwalNotif =
        tanggalNotif.map((date) => DateFormat('y-MM-d').format(date)).toList();

    List<String> hariNotif = tanggalNotif
        .map((date) => DateFormat('EEEE', "id_ID").format(date))
        .toList();

    getJadwalNotif() async {
      for (var i = 0; i < 3; i++) {
        var jadwal =
            await guruController.getJadwal(hariNotif[i], jadwalNotif[i]);
        var data = jsonDecode(jadwal!);
        var jadwalMengajar = data['jadwal-mengajar'];
        var jadwalPengganti = data['jadwal-pengganti'];
        for (var j = 0; j < jadwalMengajar.length; j++) {
          //SET NOTIF
          DateTime scheduleTime = DateTime.parse('${jadwalNotif[i]} ' +
              '' +
              '${jadwalMengajar[j]['waktu_mulai']}');
          DateTime sekarang = DateTime.now();

          if (scheduleTime.isBefore(sekarang)) {
            // print('dah lewat');
          } else {
            var idSchedule =
                scheduleTime.millisecondsSinceEpoch.toString().substring(0, 5);
            NotificationService().scheduleNotification(
                id: int.parse(idSchedule),
                title: 'Jadwal Mengajar',
                body:
                    '${jadwalMengajar[j]['mata_pelajaran']['nama']} di ${jadwalMengajar[j]['kelas']['nama']} pada jam $scheduleTime',
                scheduledNotificationDateTime:
                    scheduleTime.subtract(const Duration(minutes: 10)));
          }
        }

        for (var j = 0; j < jadwalPengganti.length; j++) {
          //SET NOTIF
          DateTime scheduleTime = DateTime.parse('${jadwalNotif[i]} ' +
              '' +
              '${jadwalPengganti[j]['waktu_mulai']}');
          DateTime sekarang = DateTime.now();
          if (scheduleTime.isBefore(sekarang)) {
          } else {
            var idSchedule =
                scheduleTime.millisecondsSinceEpoch.toString().substring(0, 5);
            NotificationService().scheduleNotification(
                id: int.parse(idSchedule),
                title: 'Jadwal Mengajar',
                body:
                    '${jadwalPengganti[j]['jadwal_pelajaran']['mata_pelajaran']['nama']} di ${jadwalPengganti[j]['jadwal_pelajaran']['kelas']['nama']}pada jam $scheduleTime',
                scheduledNotificationDateTime:
                    scheduleTime.subtract(const Duration(minutes: 10)));
          }
        }
      }
      return 'tes';
    }

    getGuru();
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    int weekday = nows.weekday;
    DateTime firstDayOfWeek = nows.subtract(Duration(days: weekday - 1));
    List<DateTime> datesOfWeek = [];
    for (int i = 0; i < 6; i++) {
      datesOfWeek.add(firstDayOfWeek.add(Duration(days: i)));
    }
    List<String> tanggals =
        datesOfWeek.map((date) => DateFormat('dd').format(date)).toList();

    var now = DateTime.now();
    String formatter = DateFormat('EEEE', "id_ID").format(now);
    var hariAktif = formatter.obs;
    String tanggalHariIni = DateFormat('y-M-d', "id_ID").format(now);

    return Scaffold(
      backgroundColor: const Color(0xffF8FBFD),
      body: FutureBuilder(
        future: getJadwalNotif(),
        builder: (BuildContext context, AsyncSnapshot snapshot) =>
            FutureBuilder(
                future: getGuru(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: heightApp * 0.15,
                              child: ListTile(
                                  // contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  leading: Container(
                                    child: CircleAvatar(
                                      radius: heightApp * 0.05,
                                      child:
                                          Image.asset("assets/images/guru.png"),
                                    ),
                                  ),
                                  title: Text(namaGuru.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(172, 3, 3, 11))),
                                  subtitle: Text(
                                    role.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    color: Colors.white,
                                    icon: Icon(Icons.menu, color: Colors.black),
                                    onSelected: (String value) {
                                      if (value == "logout") {
                                        Get.defaultDialog(
                                            radius: 4,
                                            title: 'Logout',
                                            middleText:
                                                'Anda yakin ingin Logout ?',
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
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ))),
                                                child: const Text('Lanjutkan'),
                                              )
                                            ]);
                                      }
                                      if (value == "ubahPassword") {
                                        getUsername() async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
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
                                  //  IconButton(
                                  //     color: Colors.black,
                                  //     onPressed: () async => Get.defaultDialog(
                                  //             radius: 4,
                                  //             title: 'Logout',
                                  //             middleText:
                                  //                 'Anda yakin ingin Logout ?',
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
                                  //                           BorderRadius.circular(
                                  //                               4.0),
                                  //                     ))),
                                  //               )
                                  //             ]),
                                  //     icon: const Icon(Icons.logout_sharp)),
                                  ),
                            ),
                            Container(
                                // height: heightApp * 0.05,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: heightApp * 0.01),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Jadwal Piket",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(172, 3, 3, 11)),
                                )),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: heightApp * 0.12,
                                  width: widthApp * 0.95,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: widthApp * 0.075,
                                          right: widthApp * 0.075),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "$hariPiket",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      172, 3, 3, 11)),
                                            ),
                                            Text(
                                              "$waktuPiket WIB",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      172, 3, 3, 11)),
                                            )
                                          ]),
                                    ),
                                    SizedBox(
                                      height: heightApp * 0.015,
                                    ),
                                    SizedBox(
                                      height: heightApp * 0.045,
                                      width: widthApp * 0.8,
                                      child: ElevatedButton(
                                        onPressed: hariPiket == '-'
                                            ? null
                                            : () => Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return const ValidasiKelas();
                                                })),
                                        child: const Text("VALIDASI"),
                                        style: hariPiket == '-'
                                            ? const ButtonStyle()
                                            : ButtonStyle(
                                                backgroundColor:
                                                    const MaterialStatePropertyAll(
                                                        Color(0xFF1363DF)),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ))),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                                height: heightApp * 0.07,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Jadwal Mengajar",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(172, 3, 3, 11)),
                                )),
                            SizedBox(
                              height: heightApp * 0.075,
                              width: widthApp * 0.95,
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: hari.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: widthApp * 0.01,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  var warnaTombol = const Color(0xffECEFF3);
                                  var warnaTombolAktif =
                                      const Color(0xff1363DF);
                                  var warnaTextHitam = Colors.black;
                                  var warnaTextPutih = Colors.white;

                                  return Obx(() => GestureDetector(
                                        onTapDown: (_) {
                                          // print(hariAktif);
                                          String formatTanggal =
                                              DateFormat('y-MM-', "id_ID")
                                                  .format(datesOfWeek[index]);

                                          hariAktif.value = hari[index];
                                          tanggalHariIni =
                                              formatTanggal + tanggals[index];
                                          print(tanggalHariIni);
                                        },
                                        child: Container(
                                          width: widthApp * 0.15,
                                          decoration: BoxDecoration(
                                              color:
                                                  hariAktif.value == hari[index]
                                                      ? warnaTombolAktif
                                                      : warnaTombol,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 226, 223, 223),
                                                  width: 1)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                hari[index]
                                                    .toString()
                                                    .substring(0, 3),
                                                style: TextStyle(
                                                    color: hariAktif.value ==
                                                            hari[index]
                                                        ? warnaTextPutih
                                                        : warnaTextHitam,
                                                    fontSize: 12),
                                              ),
                                              Text(tanggals[index],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: hariAktif.value ==
                                                            hari[index]
                                                        ? warnaTextPutih
                                                        : warnaTextHitam,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            SizedBox(
                              height: heightApp * 0.02,
                            ),
                            // Container(
                            //     padding: const EdgeInsets.only(
                            //       left: 20,
                            //       top: 20,
                            //     ),
                            //     alignment: Alignment.centerLeft,
                            //     child: const Text(
                            //       "Jam",
                            //       style: TextStyle(fontSize: 14),
                            //     )),
                            Obx(() => Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  width: widthApp * 0.95,
                                  child: FutureBuilder(
                                      future: guruController.getJadwal(
                                          hariAktif.toString(), tanggalHariIni),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        // print("ini print snapshot");
                                        // print(snapshot.hasData);
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              heightFactor: 4,
                                              child: SizedBox(
                                                height: heightApp * 0.05,
                                                child: const LoadingIndicator(
                                                  indicatorType: Indicator
                                                      .ballSpinFadeLoader,
                                                  strokeWidth: 1,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 33, 86, 243),
                                                    Colors.red,
                                                    Color.fromARGB(
                                                        255, 216, 142, 23),
                                                  ],
                                                ),
                                              ));
                                        }
                                        if (snapshot.hasData) {
                                          var data = jsonDecode(snapshot.data);
                                          if (data['jadwal-pengganti'].length ==
                                              0) {
                                            lengthJadwalPengganti = 0;
                                          } else {
                                            lengthJadwalPengganti =
                                                data['jadwal-pengganti'].length;
                                          }
                                          if (data['jadwal-mengajar'].length ==
                                              0) {
                                            return SizedBox(
                                              height: heightApp * 0.3,
                                              child: const Center(
                                                child: Text(
                                                  "Tidak Ada Jadwal Mengajar",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      data['jadwal-mengajar']
                                                          .length,
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                      height: 0,
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (context, index) {
                                                    var kelas =
                                                        data['jadwal-mengajar']
                                                                [index]['kelas']
                                                            ['nama'];
                                                    var jamDiMulai =
                                                        data['jadwal-mengajar']
                                                                [index]
                                                            ['waktu_mulai'];
                                                    var jamBerakhir =
                                                        data['jadwal-mengajar']
                                                                [index]
                                                            ['waktu_berakhir'];
                                                    var mapel =
                                                        data['jadwal-mengajar']
                                                                    [index][
                                                                'mata_pelajaran']
                                                            ['nama'];
                                                    var jadwalID =
                                                        data['jadwal-mengajar']
                                                            [index]['id'];
                                                    var kelasID =
                                                        data['jadwal-mengajar']
                                                                [index]['kelas']
                                                            ['id'];
                                                    var hariAktifNow =
                                                        hariAktif;

                                                    var monitoringLength = 0;
                                                    if (data['jadwal-mengajar']
                                                                    [index][
                                                                'monitoring_pembelajarans']
                                                            .length ==
                                                        1) {
                                                      monitoringLength = 1;
                                                    }

                                                    // print(
                                                    //     'ini monitoring length terbaru mengajar = $monitoringLength');
                                                    var iniIndex = index;
                                                    var jumlahDataMengajar =
                                                        data['jadwal-mengajar']
                                                            .length;

                                                    // print('ini index : $iniIndex');
                                                    // print(
                                                    //     'ini data Length : $jumlahDataMengajar');

                                                    return JadwalMengajar(
                                                        monitoringLength,
                                                        iniIndex,
                                                        jumlahDataMengajar,
                                                        widthApp,
                                                        jamAktif,
                                                        jamDiMulai,
                                                        jamBerakhir,
                                                        kelas,
                                                        mapel,
                                                        jadwalID,
                                                        kelasID,
                                                        hariAktifNow);
                                                  },
                                                  scrollDirection:
                                                      Axis.vertical,
                                                ),
                                                Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            top: 10,
                                                            bottom: 10),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      "Jam Pengganti",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    )),
                                                lengthJadwalPengganti == 0
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: heightApp *
                                                                    0.1,
                                                                bottom:
                                                                    heightApp *
                                                                        0.1),
                                                        child: const Text(
                                                          "Tidak Ada Jadwal Pengganti",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                      )
                                                    : ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            lengthJadwalPengganti,
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return const SizedBox(
                                                            height: 5,
                                                          );
                                                        },
                                                        itemBuilder:
                                                            (context, index) {
                                                          var kelas = data[
                                                                          'jadwal-pengganti']
                                                                      [index][
                                                                  'jadwal_pelajaran']
                                                              ['kelas']['nama'];
                                                          var jamDiMulai =
                                                              data['jadwal-pengganti']
                                                                      [index][
                                                                  'waktu_mulai'];
                                                          var jamBerakhir =
                                                              data['jadwal-pengganti']
                                                                      [index][
                                                                  'waktu_berakhir'];
                                                          var mapel = data[
                                                                          'jadwal-pengganti']
                                                                      [index][
                                                                  'jadwal_pelajaran']
                                                              [
                                                              'mata_pelajaran']['nama'];
                                                          var jadwalID = data[
                                                                      'jadwal-pengganti']
                                                                  [index][
                                                              'jadwal_pelajaran_id'];
                                                          var kelasID =
                                                              data['jadwal-pengganti']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'jadwal_pelajaran']
                                                                  [
                                                                  'kelas']['id'];
                                                          var hariAktifNow =
                                                              hariAktif;
                                                          var monitoringLength =
                                                              0;
                                                          if (data['jadwal-pengganti']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'jadwal_pelajaran']
                                                                      [
                                                                      'monitoring_pembelajarans']
                                                                  .length ==
                                                              1) {
                                                            monitoringLength =
                                                                1;
                                                          }

                                                          // print(
                                                          //     'ini monitoring length terbaru = $monitoringLength');
                                                          var iniIndexpengganti =
                                                              index;
                                                          var jumlahDataPengganti =
                                                              lengthJadwalPengganti;

                                                          // print(
                                                          //     'ini index : $iniIndexpengganti');
                                                          // print(
                                                          //     'ini data Length pengganti : $jumlahDataPengganti');

                                                          return JadwalMengajar(
                                                              monitoringLength,
                                                              iniIndexpengganti,
                                                              jumlahDataPengganti,
                                                              widthApp,
                                                              jamAktif,
                                                              jamDiMulai,
                                                              jamBerakhir,
                                                              kelas,
                                                              mapel,
                                                              jadwalID,
                                                              kelasID,
                                                              hariAktifNow);
                                                        },
                                                        scrollDirection:
                                                            Axis.vertical,
                                                      )
                                              ],
                                            );
                                          }
                                        } else {
                                          return SizedBox(
                                            height: heightApp * 0.3,
                                            child: const Center(
                                              child: Text(
                                                "Periksa jaringan internet anda",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                ))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(''),
                        ],
                      ),
                    );
                  }
                }),
      ),
    );
  }
}
