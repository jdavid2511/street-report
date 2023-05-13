import 'package:flutter/material.dart';
import 'package:street_report/screens/map_screen.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Street report',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: MapScreen(),
    );
  }
}

class geolocation extends StatefulWidget {
  const geolocation({super.key});

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

  void getCurrentLocation() async {
    Position position = await determinePosition();
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
