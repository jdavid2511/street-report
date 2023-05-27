import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:street_report/src/user/mapScreenUsuarioPage.dart';

class MapMarker {
  const MapMarker({
    required this.title,
    required this.description,
    required this.location,
    required this.accidentData,
  });
  final String title;
  final String description;
  final LatLng location;
  final List<AccidentData> accidentData;
}

final _locations = [
  LatLng(8.226577806176161, -73.33484629464142),
  LatLng(8.227242700238763, -73.34208655507727),
];

final mapMarkers = [
  MapMarker(
      title: 'Indice de accidente alto',
      description: 'Primero de mayo',
      location: _locations[0],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 6),
        AccidentData('Lecionados', 'Motos', 9),
        AccidentData('Lecionados', 'Peatones', 3),
        AccidentData('Muertos', 'Carros', 2),
        AccidentData('Muertos', 'Motos', 20),
        AccidentData('Muertos', 'Peatones', 8),
      ]),
  MapMarker(
      title: 'Indice de accidente alto',
      description: 'Avenida cincunvalar',
      location: _locations[1],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 15),
        AccidentData('Lecionados', 'Motos', 5),
        AccidentData('Lecionados', 'Peatones', 3),
        AccidentData('Muertos', 'Carros', 2),
        AccidentData('Muertos', 'Motos', 8),
        AccidentData('Muertos', 'Peatones', 5),
      ])
];

class AccidentData {
  final String type;
  final String vehicleType;
  final int value;

  AccidentData(this.type, this.vehicleType, this.value);
}
