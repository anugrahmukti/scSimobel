class ApiEndPoints {
  static final String baseUrl = 'https://simobel.my.id/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String logout = 'logout';
  final String login = 'login';
  final String jadwal = 'get-jadwal';
  final String siswa = 'get-siswa';
  final String presensiPembelajaran = 'presensi-pembelajaran';
  final String validasi = 'validasi';
  final String valid = 'validasi/valid';
  final String tidakValid = 'validasi/tidak-valid';
  final String kegiatanSiswa = 'get-jadwal-siswa';
  final String kegiatanNonAkademik = 'get-jadwal-non-akademik';
  final String jadwalWaliAsrama = 'get-jadwal-waliasrama';
  final String getKeterlaksanaanGuru = 'get-keterlaksanaan-guru';
  final String getDaftarPertemuanGuru = 'get-daftar-pertemuan-guru';
  final String getKelasWasrama = 'get-kelas-angkatan';
  final String getSiswaAsrama = 'get-presensi-siswa';
  final String inputPresKegTanpaNara = 'input-presensi-kegiatan';
  final String inputPresKegNara = 'input-presensi-kegiatan-narasumber';
  final String getNarasumber = 'get-narasumber';
  final String updateRolePimpinan = 'status-pimpinan';
  final String getMonitoringAkademik = 'get-persentase';
  final String getKelasAkademik = 'get-kelas-monitoring';
  final String detailMonitoringAkademik = 'detail-monitoring';
  final String getMonitoringNonAkademik = 'get-persentase-non-akademik';
  final String detailMonitoringNonAkademik = 'detail-monitoring-non-akademik';
  final String getKelasNonAkademik = 'get-kelas-monitoring-non-akademik';
  final String getRekapKehadiranPembelajaran =
      'get-rekap-kehadiran-pembelajaran';
  final String getDPKpimpnan = 'get-daftar-kegiatan';
  final String getKSKpimpinan = 'get-rekap-kehadiran-kegiatan';
  final String getRekapWaliAsrama = 'get-daftar-kegiatan';
  final String getRekapPembelajaranSiswa = 'get-rekap-pembelajaran-siswa';
  final String getRekapKegiatanSiswa = 'get-rekap-kegiatan-siswa';
  final String ubahPassword = 'ubah-password';
}
