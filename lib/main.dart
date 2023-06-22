import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:statusbarz/statusbarz.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:simobel/screens/pages/guru_page/dashboard_guru.dart';
import 'package:simobel/screens/pages/guru_page/rekapPage.dart';
import 'package:simobel/screens/pages/pimpinan_page/dashboard_pimpinan.dart';
import 'package:simobel/screens/pages/pimpinan_page/rekap_pimpinan.dart';
import 'package:simobel/screens/pages/wAsrama_page/dashboard_waliAsrama.dart';
import 'package:simobel/screens/pages/wAsrama_page/rekapPage_asrama.dart';
import 'package:simobel/screens/pages/wMurid_page/dashboard_Wmurid.dart';
import 'package:simobel/screens/pages/wMurid_page/rekap_page_wMurid.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeNotifications();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic token = prefs.get('token');
  await initializeDateFormatting('id_ID');
  tz.initializeTimeZones();
  bool isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
  if (isFirstOpen) {
    print('first');
    print(token);
    runApp(StatusbarzCapturer(
      child: GetMaterialApp(
        navigatorObservers: [Statusbarz.instance.observer],
        theme: ThemeData(
            fontFamily: 'Poppins', primaryColor: const Color(0xff1363DF)
            // scaffoldBackgroundColor: const Color(0xffF9FBFD)
            ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(token: token),
      ),
    ));
    await prefs.setBool('isFirstOpen', false);
  } else {
    print('nosplash');
    print(token);
    runApp(StatusbarzCapturer(
      child: GetMaterialApp(
        navigatorObservers: [Statusbarz.instance.observer],
        theme: ThemeData(
            fontFamily: 'Poppins', primaryColor: const Color(0xff1363DF)
            // scaffoldBackgroundColor: const Color(0xffF9FBFD)
            ),
        debugShowCheckedModeBanner: false,
        home: token == null ? const AuthScreen() : const Dashboard(),
      ),
    ));
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  dynamic role;
  dynamic pimpinan;

  // LogoutController logoutController = Get.put(LogoutController());

  List<Widget> showHome = [const Text(''), const Text('')];
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    role = prefs.get('role');

    print(role);
    if (role == 'guru') {
      showHome = [const GuruDashboard(), const RekapKehadiran()];
    } else if (role == 'siswa') {
      showHome = [const DashboardWaliMurid(), const RekapKehadiranSiswa()];
    } else if (role == 'wali_asrama') {
      showHome = [WaliAsramaDashboard(), const RekapWaliAsrama()];
    } else if (role == 'pimpinan') {
      showHome = [DashboardPimpinan(), RekapPimpinan()];
    } else {
      Get.offAll(() => AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              showHome[_selectedIndex]),
      // NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Rekapitulasi",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff1363DF),
        onTap: _onItemTapped,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final dynamic token;

  const SplashScreen({Key? key, this.token}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    Get.offAll(
        () => widget.token == null ? const AuthScreen() : const Dashboard());
  }

  @override
  Widget build(BuildContext context) {
    final heightApp = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: heightApp * 0.3,
              child: Image.asset("assets/images/logo.png"),
            ),
            SizedBox(
              height: heightApp * 0.07,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                strokeWidth: 1,
                colors: [
                  Color.fromARGB(255, 33, 86, 243),
                  Colors.red,
                  Color.fromARGB(255, 216, 142, 23),
                ],
              ),
            ),
            // Text('Loading'),
          ],
        ),
      ),
    );
  }
}
