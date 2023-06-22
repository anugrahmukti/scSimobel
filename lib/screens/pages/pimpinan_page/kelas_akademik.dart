// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:simobel/controllers/pimpinan_controller.dart';
import 'package:simobel/screens/pages/pimpinan_page/detail_akademik.dart';

class KelasAkademik extends StatelessWidget {
  KelasAkademik(this.waktuMulai, this.waktuSelesai, this.tanggal, this.hari,
      {super.key});
  late final dynamic waktuMulai;
  late final dynamic waktuSelesai;
  late final dynamic tanggal;
  late final dynamic hari;

  @override
  Widget build(BuildContext context) {
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
                future: PimpinanController().getKelas(),
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
                      padding: EdgeInsets.symmetric(vertical: heightApp * 0.01),
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return DetailAkademik(namaKelas, waktuMulai,
                                    waktuSelesai, tanggal, hari, kelasId);
                              }));
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: heightApp * 0.5,
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
