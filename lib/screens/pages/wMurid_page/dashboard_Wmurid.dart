import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/controllers/logout_controller.dart';
import 'package:simobel/screens/auth/widgets/ubahPassword.dart';
import 'package:simobel/screens/pages/wMurid_page/tabBar_NonAkademik.dart';
import 'package:simobel/screens/pages/wMurid_page/tabBar_akademik.dart';

class DashboardWaliMurid extends StatefulWidget {
  const DashboardWaliMurid({super.key});

  @override
  State<DashboardWaliMurid> createState() => _DashboardWaliMuridState();
}

class _DashboardWaliMuridState extends State<DashboardWaliMurid> {
  @override
  void initState() {
    super.initState();
    getSiswa();
  }

  dynamic role;
  dynamic namaSiswa;
  dynamic kelas;
  dynamic username;

  LogoutController logoutController = Get.put(LogoutController());

  final List<Widget> aksiUbahPassword = [
    TextButton(
      child: const Text(
        'Batal',
        style: TextStyle(color: Color(0xffB54542)),
      ),
      onPressed: () {
        // print(selectedMapel);
        Get.back();
      },
    ),
    ElevatedButton(
        style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Color(0xFF1363DF)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ))),
        onPressed: () {},
        child: const Text('Simpan')),
  ];

  getSiswa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    namaSiswa = prefs.get('namaSiswa');
    role = prefs.get('role');
    kelas = prefs.get('kelas');
    username = prefs.get('username');
    return 'tes';
  }

  @override
  Widget build(BuildContext context) {
    final heightApp = MediaQuery.of(context).size.height;

    // print('tanggal index $tanggalIndex');

    return Scaffold(
      backgroundColor: Color(0xff1C67DC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(heightApp * 0.15),
        child: SafeArea(
          child: FutureBuilder(
              future: getSiswa(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
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
                              child: Image.asset("assets/images/student.png"),
                            ),
                            title: Text(
                              namaSiswa,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            subtitle: Text(
                              '${toBeginningOfSentenceCase(role)!} ' '$kelas',
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.only(top: heightApp * 0.02),
              height: heightApp * 0.85,
              child: Column(
                children: [
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            indicatorColor: Colors.white,
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
                                ItemAkademik(),
                                ItemNonAkademik()
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
            )
          ],
        ),
      ),
    );
  }
}
