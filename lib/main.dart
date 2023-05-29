import 'package:flutter/material.dart';
import 'package:street_report/src/entity/mapScreenEntidadPage.dart';
import 'package:street_report/src/reports/reportScreen.dart';
import 'package:street_report/src/screens/login/login_page.dart';
import 'package:street_report/src/user/mapScreenUsuarioPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:street_report/src/screens/register/registerUserPage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Street report',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'user/mapscreen': (BuildContext context) => const MapScreenUsuario(),
        'entity/mapscreen': (BuildContext contex) => const MapScreenEntidad(),
        'reports/screen': (BuildContext context) => const ReportScreen(),
      },
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
    );
  }
}

class geolocation extends StatefulWidget {
  const geolocation({
    Key? key,
  }) : super(key: key);

  @override
  State<geolocation> createState() => _geolocationState();
}

class _geolocationState extends State<geolocation> {
  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
