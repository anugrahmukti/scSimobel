import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/controllers/logout_controller.dart';
import 'package:simobel/screens/pages/pimpinan_page/tabBar_NonAkademik.dart';
import 'package:simobel/screens/pages/pimpinan_page/tabBar_akademik.dart';

import '../../auth/widgets/ubahPassword.dart';

// ignore: must_be_immutable
class DashboardPimpinan extends StatelessWidget {
  late dynamic namaPimpinan = '';
  late dynamic role = '';
  late dynamic username;

  getProfilPimpinan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    namaPimpinan = prefs.get('namaGuru')!;
    role = prefs.get('role')!;
    username = prefs.get('username');
    return 'tes';
  }

  @override
  Widget build(BuildContext context) {
    final heightApp = MediaQuery.of(context).size.height;
    //
    return Scaffold(
      backgroundColor: Color(0xff1C67DC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(heightApp * 0.15),
        child: SafeArea(
          child: FutureBuilder(
              future: getProfilPimpinan(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var rolePimpinan = toBeginningOfSentenceCase(role.toString());
                  return AppBar(
                    backgroundColor: Color(0xff1C67DC),
                    elevation: 0,
                    automaticallyImplyLeading:
                        false, // Untuk menghapus tombol kembali bawaan AppBar
                    flexibleSpace: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                            leading: CircleAvatar(
                              radius: heightApp * 0.05,
                              child: Image.asset("assets/images/pimpinan.png"),
                            ),
                            title: Text(
                              namaPimpinan,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            subtitle: Text(
                              rolePimpinan!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            trailing: PopupMenuButton<String>(
                              color: Colors.white,
                              icon: Icon(Icons.menu),
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

                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return UbahPassword();
                                  //   },
                                  // );
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
                            )),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(''),
                  );
                }
              }),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: heightApp * 0.02),
          height: heightApp * 0.85,
          child: const Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 4,
                        tabs: [
                          Tab(
                              child: Text(
                            'AKADEMIK',
                            style: TextStyle(color: Colors.white),
                          )),
                          Tab(
                              child: Text(
                            'NON AKADEMIK',
                            style: TextStyle(color: Colors.white),
                          )),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ItemAkademikPimpinan(),
                            ItemNonAkademikPimpinan()
                            // ItemAkademik(tanggalIndex, hariAktif,
                            //     tanggalHariIni.value),
                            // // Text('data'),
                            // ItemNonAkademik(tanggalIndex, hariAktif,
                            //     tanggalHariIni.value),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
