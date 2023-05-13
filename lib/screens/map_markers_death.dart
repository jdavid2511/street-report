import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  const MapMarker({
    required this.title,
    required this.address,
    required this.location,
    required this.image,
  });
  final String title;
  final String address;
  final LatLng location;
  final String image;
}

final _locations = [
  LatLng(8.226577806176161, -73.33484629464142),
  LatLng(8.227242700238763, -73.34208655507727),
];

final MapMarkers = [
  MapMarker(
    title: 'Indice de accidente alto',
    address: 'Barrio primero de mayo',
    location: _locations[0],
    image: 'assets/img/logo.png',
  ),
  MapMarker(
    title: 'kjslkajs',
    address: 'ksjkajskjd',
    location: _locations[1],
    image: 'assets/img/logo.png',
  )
];
