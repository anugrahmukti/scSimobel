import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simobel/screens/pages/wMurid_page/detail_kegiatan.dart';
import 'package:timeline_tile/timeline_tile.dart';

class JadwalKegiatan extends StatefulWidget {
  final int indikatorDataAwal;
  final int indikatorDataAkhir;
  final double widthApp;
  final dynamic jamDimulai;
  final dynamic jamBerakhir;
  final dynamic mapel;
  final dynamic jadwalID;
  final dynamic hariAktifNow;
  final dynamic tanggalKegiatan;
  final dynamic statusKehadiran;
  final dynamic guruMapel;
  final dynamic topik;

  const JadwalKegiatan(
      this.indikatorDataAwal,
      this.indikatorDataAkhir,
      this.widthApp,
      this.jamDimulai,
      this.jamBerakhir,
      this.mapel,
      this.jadwalID,
      this.hariAktifNow,
      this.tanggalKegiatan,
      this.statusKehadiran,
      this.guruMapel,
      this.topik,
      {super.key});

  @override
  State<JadwalKegiatan> createState() => _JadwalKegiatanState();
}

class _JadwalKegiatanState extends State<JadwalKegiatan> {
  dynamic kelas;

  dynamic kelasID;

  String hariAktif = DateFormat('EEEE', "id_ID").format(DateTime.now());

  String jamAktif = DateFormat('H:m:s', "id_ID").format(DateTime.now());

  Color _backgroundColor = Color(0xffE3E6EB);

  @override
  Widget build(BuildContext context) {
    final heightApp = MediaQuery.of(context).size.height;
    return TimelineTile(
      // isFirst: indikatorDataAwal == 0,
      isLast: widget.indikatorDataAwal == widget.indikatorDataAkhir - 1,
      beforeLineStyle: LineStyle(
          thickness: widget.widthApp * 0.004, color: const Color(0xff051D2D)),
      indicatorStyle: IndicatorStyle(
          width: widget.widthApp * 0.017, color: const Color(0xff051D2D)),
      alignment: TimelineAlign.manual,

      lineXY: 0.15,
      endChild: Padding(
        padding: EdgeInsets.only(left: 5, bottom: heightApp * 0.01),
        child: GestureDetector(
          onTapDown: (_) {
            print(widget.guruMapel);
            print(widget.topik);
            setState(() {
              _backgroundColor = const Color(0xffE8F1FE);
            });
          },
          onTapUp: (_) {
            if (widget.guruMapel != '' && widget.topik != '') {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DetailKegiatanSiswa(
                    widget.tanggalKegiatan,
                    widget.jamDimulai,
                    widget.jamBerakhir,
                    widget.statusKehadiran,
                    widget.mapel,
                    widget.guruMapel,
                    widget.topik);
              }));
            }

            setState(() {
              _backgroundColor = Color(0xffE3E6EB);
            });
          },
          onTapCancel: () {
            setState(() {
              _backgroundColor = Color(0xffE3E6EB);
            });
          },
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: widget.statusKehadiran == 'hadir'
                    ? Color(0xffD7E5F9)
                    : widget.statusKehadiran == 'Belum Terlaksana'
                        ? _backgroundColor
                        : const Color(0xffE3E6EB),
                borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            child: Center(
                child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: heightApp * 0.01),
              width: widget.widthApp,
              child: ListTile(
                dense: true,
                title: Text(
                  widget.mapel,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: widget.statusKehadiran == 'hadir'
                    ? const Text(
                        'Hadir',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      )
                    : widget.statusKehadiran == 'Belum Terlaksana'
                        ? Text(widget.statusKehadiran)
                        : const Text(
                            'Tidak Hadir',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                trailing: widget.guruMapel != '' && widget.topik != ''
                    ? const Text("Detail 》")
                    : const Text(""),
                onTap: () {
                  if (widget.guruMapel != '' && widget.topik != '') {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DetailKegiatanSiswa(
                          widget.tanggalKegiatan,
                          widget.jamDimulai,
                          widget.jamBerakhir,
                          widget.statusKehadiran,
                          widget.mapel,
                          widget.guruMapel,
                          widget.topik);
                    }));
                  }
                },
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
    );
  }
}
