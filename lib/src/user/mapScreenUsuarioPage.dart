import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_report/map_markers_death.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:street_report/src/user/MapScreenUsuarioController.dart';
import 'package:intl/intl.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGF2aWQyNTExIiwiYSI6ImNsZ3JnMGs1eTFpa2kzZ211Z3FkYXdwdGUifQ.-zKTIZtvJkEYweXRBtHzBQ';
const MAPBOX_STYLE = 'mapbox/navigation-night-v1';
const MAKER_COLOR = Colors.redAccent;
const MARKER_SIZE_EXPANDED = 45.0;
const MARKER_SIZE_SHRINK = 38.0;

class MapScreenUsuario extends StatefulWidget {
  const MapScreenUsuario({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreenUsuario> createState() => _MapScreenUsuarioState();
}

class _MapScreenUsuarioState extends State<MapScreenUsuario> {
  MapScreenUsuariosController _con = new MapScreenUsuariosController();
  List<Marker> _markersWarning = [];
  List<String> _addresses = [];
  List<MapMarker> mapMaker = [];
  Position? _currentPosition;
  bool isLoading = true;
  double currentZoom = 16.5;
  MapController mapController = MapController();
  final _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Marker> _buildMarkersDeath() {
    final _markerList = <Marker>[];
    for (int i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      _markerList.add(Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _selectedIndex = i;
                setState(() {
                  _pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticInOut);
                  print('selected: ${mapItem.title}');
                });
              },
              child: _LocationMarker(
                selected: _selectedIndex == i,
              ),
            );
          }));
    }
    return _markerList;
  }

  Future<File?> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _markerList = _buildMarkersDeath();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Street Report'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.offline_pin,
              color: Colors.white,
            ),
            onPressed: _con.logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 150.0,
                      child: ListView.builder(
                        itemCount: _markersWarning.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Obtiene la fecha actual
                          DateTime currentDate = DateTime.now();
                          // Formatea la fecha en el formato deseado
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(currentDate);
                          return ListTile(
                            title: Text('Reporte ${index + 1}'),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_addresses[index]),
                                Text(
                                    formattedDate), // Muestra la fecha al lado derecho
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          zoom: currentZoom,
                          onTap: (mapPoint, point) {
                            _con.latitudeController.text =
                                point.latitude.toString();
                            _con.longitudeController.text =
                                point.longitude.toString();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Reportar mal estado'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _con.descriptionController,
                                        decoration: InputDecoration(
                                          labelText: 'Descripción del problema',
                                        ),
                                      ),
                                      TextField(
                                        controller: _con.addressController,
                                        decoration: InputDecoration(
                                          labelText: 'Dirección',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        File? image = await _takePhoto();

                                        setState(() {
                                          _markersWarning.add(
                                            Marker(
                                              width: 60.0,
                                              height: 60.0,
                                              point: point,
                                              builder: (ctx) => GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: ctx,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Reporte'),
                                                        content: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                'Descripcion: ${_con.descriptionController.text}'),
                                                            Text(
                                                                'Direccion: ${_con.addressController.text}'),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text('Close'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.circle,
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                ),
                                              ),
                                            ),
                                          );
                                          _addresses
                                              .add(_con.addressController.text);
                                        });

                                        Navigator.of(context).pop();
                                        _con.create();
                                      },
                                      child: Text('Reportar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        nonRotatedChildren: [
                          TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                            additionalOptions: {
                              'accessToken': MAPBOX_ACCESS_TOKEN,
                              'id': MAPBOX_STYLE,
                            },
                          ),
                          MarkerLayer(
                            markers: _markerList,
                          ),
                          MarkerLayer(
                            markers: _markersWarning,
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              width: 50.0,
                              height: 50.0,
                              point: LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude),
                              builder: (ctx) => Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: mapMarkers.length,
                      itemBuilder: (context, index) {
                        final item = mapMarkers[index];
                        return _MapItemDetails(
                          mapMarker: item,
                        );
                      }),
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.small(
              onPressed: _zoomin,
              child: Icon(Icons.zoom_in),
              backgroundColor: Colors.blueAccent,
              hoverColor: Colors.blue.shade400,
            ),
            SizedBox(
              height: 8,
            ),
            FloatingActionButton.small(
              onPressed: () {
                _zoomout();
              },
              child: const Icon(Icons.zoom_out),
              backgroundColor: Colors.blueAccent,
              hoverColor: Colors.blue.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _zoomin() {
    if (currentZoom < 18.4) {
      currentZoom = currentZoom + 0.4;
      mapController.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          currentZoom);
    }
  }

  void _zoomout() {
    currentZoom = currentZoom - 0.4;
    mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        currentZoom);
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({
    Key? key,
    this.selected = false,
  }) : super(key: key);

  final bool selected;
  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINK;
    return Center(
        child: AnimatedContainer(
      height: size,
      width: size,
      duration: const Duration(milliseconds: 300),
      child: Image.asset('assets/img/esqueleto.png'),
    ));
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key? key,
    required this.mapMarker,
  }) : super(key: key);

  final MapMarker mapMarker;

  @override
  Widget build(BuildContext context) {
    final _styleTittle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleDescription = TextStyle(color: Colors.grey[800], fontSize: 14);

    final accidentData = mapMarker.accidentData;

    final series = accidentData.map((data) {
      final color = data.type == 'Lecionados'
          ? charts.MaterialPalette.blue.shadeDefault
          : charts.MaterialPalette.red.shadeDefault;
      return charts.Series<AccidentData, String>(
        id: '${data.vehicleType}-${data.value}',
        domainFn: (AccidentData data, _) => data.vehicleType,
        measureFn: (AccidentData data, _) => data.value,
        colorFn: (_, __) => color,
        data: [data],
        radiusPxFn: (AccidentData data, _) => 4,
        strokeWidthPxFn: (_, __) => 2,
        labelAccessorFn: (AccidentData data, _) => '${data.value}',
      );
    }).toList();

    final chart = charts.BarChart(
      series,
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(20),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      behaviors: [
        charts.SeriesLegend(
            position: charts.BehaviorPosition.end,
            desiredMaxRows: 3,
            desiredMaxColumns: 2,
            entryTextStyle: charts.TextStyleSpec(color: charts.Color.black)),
        charts.SeriesLegend(
          position: charts.BehaviorPosition.end,
          desiredMaxRows: 3,
          desiredMaxColumns: 1,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          entryTextStyle: charts.TextStyleSpec(color: charts.Color.black),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        mapMarker.title,
                        style: _styleTittle,
                      ),
                      Text(
                        mapMarker.description,
                        style: _styleDescription,
                      )
                    ],
                  ))
                ])),
            Expanded(
              child: Row(children: [
                Expanded(
                  child: chart,
                ),
              ]),
            ),
            /*MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () => null,
              color: Colors.blueAccent,
              elevation: 6,
              child: Text(
                'Cerrar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
