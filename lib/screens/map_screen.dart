import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_report/screens/map_markers_death.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGF2aWQyNTExIiwiYSI6ImNsZ3JnMGs1eTFpa2kzZ211Z3FkYXdwdGUifQ.-zKTIZtvJkEYweXRBtHzBQ';
const MAPBOX_STYLE = 'mapbox/streets-v12';
const MAKER_COLOR = Colors.redAccent;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markersWarning = [];
  List<String> _addresses = [];
  List<MapMarker> MapMaker = [];
  Position? _currentPosition;
  bool isLoading = true;
  double currentZoom = 18.0;
  MapController mapController = MapController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool isPageViewOpen = false;
  final _pageController = PageController();

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
    for (int i = 0; i < MapMarkers.length; i++) {
      final mapItem = MapMarkers[i];
      _markerList.add(Marker(
          height: 60.0,
          width: 60.0,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticInOut);
                print('selected: ${mapItem.title}');
              },
              child: Icon(
                Icons.person_pin_circle_outlined,
                color: Color.fromARGB(144, 255, 0, 0),
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
                            return ListTile(
                              title: Text('Reporte ${index + 1}'),
                              subtitle: Text(_addresses[index]),
                            );
                          }),
                    ),
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          zoom: currentZoom,
                          onTap: (mapPoint, point) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Reportar mal estado'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                          labelText: 'Descripción del problema',
                                        ),
                                      ),
                                      TextField(
                                        controller: _addressController,
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
                                        String description =
                                            _descriptionController.text;
                                        String address =
                                            _addressController.text;
                                        File? image = await _takePhoto();

                                        setState(() {
                                          _markersWarning.add(
                                            Marker(
                                              width: 60.0,
                                              height: 60.0,
                                              point: point,
                                              builder: (ctx) => Icon(
                                                Icons.warning,
                                                color: Color.fromARGB(
                                                    255, 255, 136, 0),
                                              ),
                                            ),
                                          );
                                          _addresses
                                              .add(_addressController.text);
                                        });
                                        _addressController.clear();
                                        _descriptionController.clear();
                                        Navigator.of(context).pop();
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
                                size: 50.0,
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
                      controller: _pageController,
                      itemCount: MapMarkers.length,
                      itemBuilder: (context, index) {
                        final item = MapMarkers[index];
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
    if (currentZoom < 18) {
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
    final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        child: Row(children: [
          Expanded(
            child: Image.asset(mapMarker.image),
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mapMarker.title,
                style: _styleTittle,
              ),
              Text(
                mapMarker.address,
                style: _styleAddress,
              )
            ],
          ))
        ]),
      ),
    );
  }
}
