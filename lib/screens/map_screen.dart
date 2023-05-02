import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_report/screens/map_marker.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGF2aWQyNTExIiwiYSI6ImNsZ3JnMGs1eTFpa2kzZ211Z3FkYXdwdGUifQ.-zKTIZtvJkEYweXRBtHzBQ';
const MAPBOX_STYLE = 'mapbox/streets-v12';
const MAKER_COLOR = Colors.redAccent;

final myPosition = LatLng(8.226879018057176, -73.33836592227479);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markers = [];
  double currentZoom = 15.0;
  MapController mapController = MapController();
  final _problemDescriptionController = TextEditingController();
  String _problemDescription = '';

  Future<void> _takePhoto() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera, // or ImageSource.gallery
    );
    if (pickedFile != null) {
      // Save the photo to a database here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Street Report'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.gps_fixed_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              getCurrentLocation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: myPosition,
                zoom: currentZoom,
                onTap: (mapPoint, point) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Reportar mal estado'),
                        content: TextField(
                          decoration: InputDecoration(
                            labelText: 'Descripción del problema',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _markers.add(
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: point,
                                    builder: (ctx) => Icon(
                                      Icons.warning,
                                      color: Color.fromARGB(255, 255, 136, 0),
                                    ),
                                  ),
                                );
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Reportar'),
                          ),
                          TextButton(
                            onPressed: _takePhoto,
                            child: Text('Tomar foto'),
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
                  markers: _markers,
                ),
              ],
            ),
          ),
          Container(
              height: 200.0,
              child: ListView.builder(
                  itemCount: _markers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Reporte ${index + 1}'),
                      subtitle: Text(_markers[index].point.toString()),
                    );
                  })),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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

  void _zoomout() {
    currentZoom = currentZoom - 0.5;
    mapController.move(myPosition, currentZoom);
  }

  void _zoomin() {
    currentZoom = currentZoom + 0.5;
    mapController.move(myPosition, currentZoom);
  }
}
