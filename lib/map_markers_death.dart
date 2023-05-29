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
  LatLng(8.236787218273811, -73.34553762698646),
  LatLng(8.25054895884869, -73.3580871797724),
  LatLng(8.234202894024554, -73.35179000903737),
  LatLng(8.265034215937833, -73.36183842385454),
  LatLng(8.236916949088029, -73.35757392440397),
  LatLng(8.275578267957561, -73.36785816426358)
];

final mapMarkers = [
  MapMarker(
      title: 'Indice de accidente alto',
      description: 'cincunvalar camino real',
      location: _locations[0],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 4),
        AccidentData('Lecionados', 'Motos', 6),
        AccidentData('Lecionados', 'Peatones', 0),
        AccidentData('Muertos', 'Carros', 2),
        AccidentData('Muertos', 'Motos', 4),
        AccidentData('Muertos', 'Peatones', 0),
      ]),
  MapMarker(
      title: 'Indice de accidente alto',
      description: 'Y de Avenida fernadez de contreras con 1° de mayo',
      location: _locations[1],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 5),
        AccidentData('Lecionados', 'Motos', 10),
        AccidentData('Lecionados', 'Peatones', 2),
        AccidentData('Muertos', 'Carros', 2),
        AccidentData('Muertos', 'Motos', 3,),
        AccidentData('Muertos', 'Peatones', 0),
      ]),
      MapMarker(
      title: 'Indice de accidente alto',
      description: 'Esquina de Bancamia',
      location: _locations[2],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 0,),
        AccidentData('Lecionados', 'Motos', 3,),
        AccidentData('Lecionados', 'Peatones', 0),
        AccidentData('Muertos', 'Carros', 0),
        AccidentData('Muertos', 'Motos', 2,),
        AccidentData('Muertos', 'Peatones', 0),
      ]),
       MapMarker(
      title: 'Indice de accidente alto',
      description: 'Santa clara',
      location: _locations[3],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 5,),
        AccidentData('Lecionados', 'Motos', 8,),
        AccidentData('Lecionados', 'Peatones', 3),
        AccidentData('Muertos', 'Carros', 1,),
        AccidentData('Muertos', 'Motos', 3,),
        AccidentData('Muertos', 'Peatones', 0),
      ]),
       MapMarker(
      title: 'Indice de accidente alto',
      description: 'calle cementerio central',
      location: _locations[4],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 0,),
        AccidentData('Lecionados', 'Motos', 3,),
        AccidentData('Lecionados', 'Peatones', 0),
        AccidentData('Muertos', 'Carros', 1),
        AccidentData('Muertos', 'Motos', 2,),
        AccidentData('Muertos', 'Peatones', 0),
      ]),
      MapMarker(
      title: 'Indice de accidente alto',
      description: 'calle cementerio la esperanza',
      location: _locations[5],
      accidentData: [
        AccidentData('Lecionados', 'Carros', 3,),
        AccidentData('Lecionados', 'Motos', 3,),
        AccidentData('Lecionados', 'Peatones', 1,),
        AccidentData('Muertos', 'Carros', 0),
        AccidentData('Muertos', 'Motos', 2,),
        AccidentData('Muertos', 'Peatones', 0),
      ]),
];

class AccidentData {
  final String type;
  final String vehicleType;
  final int value;

  AccidentData(this.type, this.vehicleType, this.value);
}
