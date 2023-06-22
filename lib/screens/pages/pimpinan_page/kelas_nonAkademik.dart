// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/pimpinan_controller.dart';
import 'package:simobel/screens/pages/pimpinan_page/detail_NonAkademik.dart';

class KelasNonAkademik extends StatelessWidget {
  KelasNonAkademik(this.angkatanId, this.tanggal, this.hari, this.namaKegiatan,
      this.kegiatanId, this.waktuMulai, this.waktuBerakhir,
      {super.key});
  late final dynamic angkatanId;
  late final dynamic tanggal;
  late final dynamic hari;
  late final dynamic namaKegiatan;
  late final dynamic kegiatanId;
  late final dynamic waktuMulai;
  late final dynamic waktuBerakhir;

  @override
  Widget build(BuildContext context) {
    print('xxxxxxxxxxxxxxx');
    print(namaKegiatan);
    print(kegiatanId);

    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
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
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          "Kelas",
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            FutureBuilder(
                future: PimpinanController().getKelasNonAkademik(angkatanId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        heightFactor: 9,
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
                    var data = jsonDecode(snapshot.data);
                    // print(data);
                    var returnKelas = data['kelas'];

                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: returnKelas.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: heightApp * 0.01,
                        );
                      },
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ]),
                          width: widthApp * 0.8,
                          // height: heightApp * 0.07,
                          child: ListTile(
                            // dense: true,
                            title: Text(returnKelas[index]['nama']),
                            // Text(returnKelas[index]['nama']),
                            trailing: Text('Detail 》'),
                            onTap: () {
                              var kelasId = returnKelas[index]['id'];
                              var namaKelas = returnKelas[index]['nama'];

                              print(namaKelas);
                              print(namaKegiatan);
                              print(kegiatanId);

                              print(waktuMulai);
                              print(waktuBerakhir);
                              print(tanggal);
                              print(hari);
                              print(kelasId);

                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                print('wwwwwwwwwwwwww');
                                print(namaKegiatan);
                                print(kegiatanId);

                                return DetailNonAkademik(
                                    namaKelas,
                                    kegiatanId,
                                    namaKegiatan,
                                    tanggal,
                                    hari,
                                    kelasId,
                                    waktuMulai,
                                    waktuBerakhir);
                              }));
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      child: Center(
                        child: Text('Periksa koneksi anda'),
                      ),
                    );
                  }
                }),
          ],
        )),
      ),
    );
  }
}
