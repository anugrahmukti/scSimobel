import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailKegiatanSiswa extends StatelessWidget {
  final String tanggalkegiatan;

  final String jamDimulai;
  final String jamBerakhir;
  // final String jam = Text(jamDimulai.toString().substring(0,5));
  final String statusKehadiran;
  final String mapel;
  final String guruMapel;
  final String topik;
  const DetailKegiatanSiswa(
      this.tanggalkegiatan,
      this.jamDimulai,
      this.jamBerakhir,
      this.statusKehadiran,
      this.mapel,
      this.guruMapel,
      this.topik,
      {super.key});

  @override
  Widget build(BuildContext context) {
    var jamAkhir = jamBerakhir.toString().substring(0, 5);
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
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
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const Text(
          "Detail",
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          // Container(
          //     height: heightApp * 0.1,
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     alignment: Alignment.centerLeft,
          //     child: const Text(
          //       "Detail",
          //       style: TextStyle(fontSize: 24),
          //     )),
          Container(
              // height: heightApp * 0.05,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: heightApp * 0.01),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Tanggal dan Waktu",
                style: TextStyle(fontSize: 16),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            // height: heightApp * 0.05,
            width: widthApp * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Text('$tanggalkegiatan | $jamDimulai WIB - $jamAkhir WIB'),
          ),
          Container(
              // height: heightApp * 0.05,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: heightApp * 0.01),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Status",
                style: TextStyle(fontSize: 16),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            // height: heightApp * 0.05,
            width: widthApp * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Text(toBeginningOfSentenceCase(statusKehadiran)!),
          ),
          Container(
              // height: heightApp * 0.05,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: heightApp * 0.01),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Mata pelajaran",
                style: TextStyle(fontSize: 16),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            // height: heightApp * 0.05,
            width: widthApp * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Text(mapel),
          ),
          Container(
              // height: heightApp * 0.05,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: heightApp * 0.01),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Guru mata pelajaran",
                style: TextStyle(fontSize: 16),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            // height: heightApp * 0.05,
            width: widthApp * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Text(guruMapel),
          ),
          Container(
              // height: heightApp * 0.05,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: heightApp * 0.01),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Agenda pembelajaran",
                style: TextStyle(fontSize: 16),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            height: heightApp * 0.11,
            width: widthApp * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Text(
              topik,
              maxLines: 3,
            ),
          ),
        ]),
      )),
    );
  }
}
