import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simobel/controllers/rekap_controller.dart';
import 'package:simobel/utils/api_Provider.dart';
import 'package:flutter/material.dart';

class MyAlert extends StatefulWidget {
  final String label;
  const MyAlert(this.label, {super.key});

  @override
  State<MyAlert> createState() => _MyAlertState();
}

class _MyAlertState extends State<MyAlert> {
  List<dynamic> kelas = [];
  List<dynamic> mapel = [];
  List<dynamic> kegiatan = [];
  List<dynamic> angkatan = [];
  String? selectedKelas = null;
  String? selectedMapel = null;
  String? selectedKegiatan = null;
  String? selectedAngkatan = null;

  Future<void> fetchDataKegiatan() async {
    try {
      print('ini fetch kegiatan');
      ApiProvider apiProvider =
          ApiProvider(apiUrl: 'https://simobel.my.id/api/get-kegiatan');
      List<dynamic> data = await apiProvider.fetchKegiatan();
      print(data);
      setState(() {
        kegiatan = data;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchDataAngkatan() async {
    try {
      ApiProvider apiProvider =
          ApiProvider(apiUrl: 'https://simobel.my.id/api/get-angkatan');
      List<dynamic> data = await apiProvider.fetchAngkatan();
      print(data);
      setState(() {
        angkatan = data;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchDataKelas() async {
    try {
      ApiProvider apiProvider =
          ApiProvider(apiUrl: 'https://simobel.my.id/api/get-kelas');
      List<dynamic> data = await apiProvider.fetchData();
      print(data);
      setState(() {
        kelas = data;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchMapelFromKelas(String kelas) async {
    try {
      ApiProvider apiProvider =
          ApiProvider(apiUrl: 'https://simobel.my.id/api/get-mapel/$kelas');
      var data = await apiProvider.fetchDataMapel();
      print(data);
      setState(() {
        if (data == null) {
          mapel = [];
        } else {
          List<dynamic> data2 = data;
          mapel = data2;
        }
        selectedMapel = null;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataKelas();
    fetchDataKegiatan();
    fetchDataAngkatan();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;

    final List<Widget> widgetDPGuru = [
      // Dropdown negara
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kelas',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKelas,
              hint: const Text('Pilih Kelas'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKelas = newValue!;
                  print(selectedKelas);
                  selectedMapel =
                      null; // Reset kota terpilih saat negara berubah
                  fetchMapelFromKelas(
                      selectedKelas!); // Ambil daftar kota berdasarkan negara terpilih
                });
              },
              items: kelas.map<DropdownMenuItem<String>>((dynamic kelas) {
                return DropdownMenuItem<String>(
                  value: kelas['id'].toString(),
                  child: Text(kelas['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      SizedBox(
        height: heightApp * 0.01,
      ),
      // Dropdown kota
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Mata Pelajaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedMapel,
              hint: const Text('Pilih Mapel'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMapel = newValue!;
                });
              },
              items: mapel.map<DropdownMenuItem<String>>((dynamic mapel) {
                return DropdownMenuItem<String>(
                  value: mapel['id'].toString(),
                  child: Text(mapel['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                        : '--/--/----',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                        : '--/--/----',
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectEndDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
    final List<Widget> widgetKGuru = [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _startDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                      : '--/--/----',
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectStartDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _endDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                      : '--/--/----',
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectEndDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    final List<Widget> aksiDaftarPertemuanGuru = [
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
          style: selectedMapel == null || _startDate == null || _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: selectedMapel == null ||
                  _startDate == null ||
                  _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapDaftarPertemuanGuru(
                      selectedKelas, selectedMapel, tanggalMulai, tanggalAkhir);
                  Get.back();
                },
          child: const Text('Download')),
    ];
    final List<Widget> aksiKeterlaksanaanGuru = [
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
          style: _startDate == null || _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: _startDate == null || _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapKeterlaksanaanGuru(
                      tanggalMulai, tanggalAkhir);
                  Get.back();

                  print(tanggalMulai);
                  print(tanggalAkhir);
                },
          child: const Text('Download')),
    ];

    final List<Widget> widgetDPPpimpinan = [
      // Dropdown negara
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kelas',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKelas,
              hint: const Text('Pilih Kelas'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKelas = newValue!;
                  print(selectedKelas);
                  selectedMapel =
                      null; // Reset kota terpilih saat negara berubah
                  fetchMapelFromKelas(
                      selectedKelas!); // Ambil daftar kota berdasarkan negara terpilih
                });
              },
              items: kelas.map<DropdownMenuItem<String>>((dynamic kelas) {
                return DropdownMenuItem<String>(
                  value: kelas['id'].toString(),
                  child: Text(kelas['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      SizedBox(
        height: heightApp * 0.01,
      ),
      // Dropdown kota
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Mata Pelajaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedMapel,
              hint: const Text('Pilih Mapel'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMapel = newValue!;
                });
              },
              items: mapel.map<DropdownMenuItem<String>>((dynamic mapel) {
                return DropdownMenuItem<String>(
                  value: mapel['id'].toString(),
                  child: Text(mapel['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                        : '--/--/----',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                        : '--/--/----',
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectEndDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
    final List<Widget> aksiDPPpimpinan = [
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
          style: selectedMapel == null || _startDate == null || _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: selectedMapel == null ||
                  _startDate == null ||
                  _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapDaftarPertemuanGuru(
                      selectedKelas, selectedMapel, tanggalMulai, tanggalAkhir);
                  Get.back();
                },
          child: const Text('Download')),
    ];

    final List<Widget> widgetKPpimpinan = [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _startDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                      : '--/--/----',
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectStartDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _endDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                      : '--/--/----',
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectEndDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    final List<Widget> aksiKPpimpinan = [
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
          style: _startDate == null || _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: _startDate == null || _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapKeterlaksanaanGuru(
                      tanggalMulai, tanggalAkhir);
                  Get.back();

                  print(tanggalMulai);
                  print(tanggalAkhir);
                },
          child: const Text('Download')),
    ];

    final List<Widget> widgetKSPpimpinan = [
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kelas',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKelas,
              hint: const Text('Pilih Kelas'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKelas = newValue!;
                  print(selectedKelas);
                  // selectedMapel =
                  //     null; // Reset kota terpilih saat negara berubah
                  // fetchMapelFromKelas(
                  //     selectedKelas!); // Ambil daftar kota berdasarkan negara terpilih
                });
              },
              items: kelas.map<DropdownMenuItem<String>>((dynamic kelas) {
                return DropdownMenuItem<String>(
                  value: kelas['id'].toString(),
                  child: Text(kelas['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _startDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                      : '--/--/----',
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectStartDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _endDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                      : '--/--/----',
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectEndDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    final List<Widget> aksiKSPpimpinan = [
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
          style: selectedKelas == null || _startDate == null || _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed:
              selectedKelas == null || _startDate == null || _endDate == null
                  ? null
                  : () {
                      var tanggalMulai = _startDate.toString().substring(0, 10);
                      var tanggalAkhir = _endDate.toString().substring(0, 10);
                      RekapController().downloadRekapKehadiranSiswaPimpinan(
                          selectedKelas, tanggalMulai, tanggalAkhir);
                      Get.back();
                    },
          child: const Text('Download')),
    ];

    final List<Widget> widgetDPKpimpinan = [
      // Dropdown negara
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kegiatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKegiatan,
              hint: const Text('Pilih kegiatan'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKegiatan = newValue!;
                  print(selectedKegiatan);
                });
              },
              items: kegiatan.map<DropdownMenuItem<String>>((dynamic kegiatan) {
                return DropdownMenuItem<String>(
                  value: kegiatan['id'].toString(),
                  child: Text(kegiatan['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      SizedBox(
        height: heightApp * 0.01,
      ),
      // Dropdown kota
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Angkatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedAngkatan,
              hint: const Text('Pilih angkatan'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedAngkatan = newValue!;
                  print(selectedAngkatan);
                });
              },
              items: angkatan.map<DropdownMenuItem<String>>((dynamic angkatan) {
                return DropdownMenuItem<String>(
                  value: angkatan['id'].toString(),
                  child: Text(angkatan['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                        : '--/--/----',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                        : '--/--/----',
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectEndDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
    final List<Widget> aksiDPKpimpinan = [
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
          style: selectedKegiatan == null ||
                  selectedAngkatan == null ||
                  _startDate == null ||
                  _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: selectedKegiatan == null ||
                  selectedAngkatan == null ||
                  _startDate == null ||
                  _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapDPKpimpinan(selectedKegiatan,
                      selectedAngkatan, tanggalMulai, tanggalAkhir);
                  Get.back();
                },
          child: const Text('Download')),
    ];
    final List<Widget> widgetKSKpimpinan = [
      // Dropdown negara
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kegiatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKegiatan,
              hint: const Text('Pilih kegiatan'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKegiatan = newValue!;
                  print(selectedKegiatan);
                });
              },
              items: kegiatan.map<DropdownMenuItem<String>>((dynamic kegiatan) {
                return DropdownMenuItem<String>(
                  value: kegiatan['id'].toString(),
                  child: Text(kegiatan['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      SizedBox(
        height: heightApp * 0.01,
      ),
      // Dropdown kota
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kelas',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKelas,
              hint: const Text('Pilih kelas'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKelas = newValue!;
                  print(selectedKelas);
                });
              },
              items: kelas.map<DropdownMenuItem<String>>((dynamic kelas) {
                return DropdownMenuItem<String>(
                  value: kelas['id'].toString(),
                  child: Text(kelas['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                        : '--/--/----',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                        : '--/--/----',
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectEndDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
    final List<Widget> aksiKSKpimpinan = [
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
          style: selectedKegiatan == null ||
                  selectedKelas == null ||
                  _startDate == null ||
                  _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: selectedKegiatan == null ||
                  selectedKelas == null ||
                  _startDate == null ||
                  _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapKSKpimpinan(selectedKegiatan,
                      selectedKelas, tanggalMulai, tanggalAkhir);
                  Get.back();
                },
          child: const Text('Download')),
    ];

    final List<Widget> widgetDPwaliAsrama = [
      // Dropdown negara
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kegiatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKegiatan,
              hint: const Text('Pilih kegiatan'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKegiatan = newValue!;
                  print(selectedKegiatan);
                });
              },
              items: kegiatan.map<DropdownMenuItem<String>>((dynamic kegiatan) {
                return DropdownMenuItem<String>(
                  value: kegiatan['id'].toString(),
                  child: Text(kegiatan['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      SizedBox(
        height: heightApp * 0.01,
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                        : '--/--/----',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                        : '--/--/----',
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectEndDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
    final List<Widget> aksiDPwaliAsrama = [
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
          style:
              selectedKegiatan == null || _startDate == null || _endDate == null
                  ? const ButtonStyle()
                  : ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xFF1363DF)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ))),
          onPressed:
              selectedKegiatan == null || _startDate == null || _endDate == null
                  ? null
                  : () {
                      var tanggalMulai = _startDate.toString().substring(0, 10);
                      var tanggalAkhir = _endDate.toString().substring(0, 10);
                      RekapController().downloadRekapWaliAsrama(
                          selectedKegiatan, tanggalMulai, tanggalAkhir);
                      Get.back();
                    },
          child: const Text('Download')),
    ];

    final List<Widget> widgetRekapKPSsiswa = [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _startDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                      : '--/--/----',
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectStartDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _endDate != null
                      ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                      : '--/--/----',
                ),
                SizedBox(width: widthApp * 0.05),
                Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Color(0xff1363DF)),
                  child: IconButton(
                    onPressed: () => _selectEndDate(context),
                    icon: const Icon(Icons.date_range),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
    final List<Widget> aksiRekapKPSsiswa = [
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
          style: _startDate == null || _endDate == null
              ? const ButtonStyle()
              : ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
          onPressed: _startDate == null || _endDate == null
              ? null
              : () {
                  var tanggalMulai = _startDate.toString().substring(0, 10);
                  var tanggalAkhir = _endDate.toString().substring(0, 10);
                  RekapController().downloadRekapPembelajaranSiswa(
                      tanggalMulai, tanggalAkhir);
                  Get.back();

                  print(tanggalMulai);
                  print(tanggalAkhir);
                },
          child: const Text('Download')),
    ];

    final List<Widget> widgetKKSsiswa = [
      // Dropdown negara
      Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Kegiatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedKegiatan,
              hint: const Text('Pilih kegiatan'),
              onChanged: (String? newValue) {
                // kelasChanged(newValue!);
                setState(() {
                  selectedKegiatan = newValue!;
                  print(selectedKegiatan);
                });
              },
              items: kegiatan.map<DropdownMenuItem<String>>((dynamic kegiatan) {
                return DropdownMenuItem<String>(
                  value: kegiatan['id'].toString(),
                  child: Text(kegiatan['nama']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      SizedBox(
        height: heightApp * 0.01,
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        // height: heightApp * 0.1,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal dimulai',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_startDate!)
                        : '--/--/----',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Tanggal Akhir',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy', "id_ID").format(_endDate!)
                        : '--/--/----',
                  ),
                  SizedBox(width: widthApp * 0.05),
                  Ink(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Color(0xff1363DF)),
                    child: IconButton(
                      onPressed: () => _selectEndDate(context),
                      icon: const Icon(Icons.date_range),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
    final List<Widget> aksiKKSsiswa = [
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
          style:
              selectedKegiatan == null || _startDate == null || _endDate == null
                  ? const ButtonStyle()
                  : ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xFF1363DF)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ))),
          onPressed:
              selectedKegiatan == null || _startDate == null || _endDate == null
                  ? null
                  : () {
                      var tanggalMulai = _startDate.toString().substring(0, 10);
                      var tanggalAkhir = _endDate.toString().substring(0, 10);
                      RekapController().downloadRekapKegiatanSiswa(
                          selectedKegiatan, tanggalMulai, tanggalAkhir);
                      Get.back();
                    },
          child: const Text('Download')),
    ];

    return AlertDialog(
      title: Text(
        'Rekap ${widget.label}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.label == 'Daftar Pertemuan'
              ? widgetDPGuru
              : widget.label == 'Keterlaksanaan'
                  ? widgetKGuru
                  : widget.label == 'Daftar Pertemuan Akademik'
                      ? widgetDPPpimpinan
                      : widget.label == 'Keterlaksanaan Akademik'
                          ? widgetKPpimpinan
                          : widget.label == 'Kehadiran Siswa Akademik'
                              ? widgetKSPpimpinan
                              : widget.label == 'Daftar Pertemuan Non-Akademik'
                                  ? widgetDPKpimpinan
                                  : widget.label ==
                                          'Kehadiran Siswa Non-Akademik'
                                      ? widgetKSKpimpinan
                                      : widget.label ==
                                              'Daftar Pertemuan Wali Asrama'
                                          ? widgetDPwaliAsrama
                                          : widget.label ==
                                                  'Kehadiran Pembelajaran Siswa'
                                              ? widgetRekapKPSsiswa
                                              : widget.label ==
                                                      'Kehadiran Kegiatan Siswa'
                                                  ? widgetKKSsiswa
                                                  : []),
      actions: widget.label == 'Daftar Pertemuan'
          ? aksiDaftarPertemuanGuru
          : widget.label == 'Keterlaksanaan'
              ? aksiKeterlaksanaanGuru
              : widget.label == 'Daftar Pertemuan Akademik'
                  ? aksiDPPpimpinan
                  : widget.label == 'Keterlaksanaan Akademik'
                      ? aksiKPpimpinan
                      : widget.label == 'Kehadiran Siswa Akademik'
                          ? aksiKSPpimpinan
                          : widget.label == 'Daftar Pertemuan Non-Akademik'
                              ? aksiDPKpimpinan
                              : widget.label == 'Kehadiran Siswa Non-Akademik'
                                  ? aksiKSKpimpinan
                                  : widget.label ==
                                          'Daftar Pertemuan Wali Asrama'
                                      ? aksiDPwaliAsrama
                                      : widget.label ==
                                              'Kehadiran Pembelajaran Siswa'
                                          ? aksiRekapKPSsiswa
                                          : widget.label ==
                                                  'Kehadiran Kegiatan Siswa'
                                              ? aksiKKSsiswa
                                              : [],
    );
  }
}
